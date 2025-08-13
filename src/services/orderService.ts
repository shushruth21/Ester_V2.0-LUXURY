import { supabase } from "@/integrations/supabase/client";
import { CartItem } from "@/contexts/CartContext";

export interface CreateOrderData {
  modelId: string;
  modelName: string;
  basePrice: number;
  totalPrice: number;
  configuration: Record<string, any>;
  customerDetails: {
    name: string;
    email: string;
    phone: string;
  };
  remarks: string;
}

export interface Order {
  id: string;
  model_id: string;
  customer_name: string;
  customer_email: string;
  customer_phone: string;
  configuration: any;
  total_price: number;
  remarks: string;
  status: string;
  created_at: string;
  updated_at: string;
}

export const createOrdersFromCart = async (cartItems: CartItem[]): Promise<Order[]> => {
  const orderPromises = cartItems.map(async (item) => {
    const orderData = {
      model_id: item.modelId,
      customer_name: item.customerDetails.name,
      customer_email: item.customerDetails.email,
      customer_phone: item.customerDetails.phone,
      configuration: {
        ...item.configuration,
        quantity: item.quantity,
        modelName: item.modelName,
        basePrice: item.basePrice
      },
      total_price: item.totalPrice * item.quantity,
      remarks: item.remarks || '',
      status: 'pending'
    };

    const { data, error } = await supabase
      .from('orders')
      .insert(orderData)
      .select()
      .single();

    if (error) {
      throw new Error(`Failed to create order: ${error.message}`);
    }

    return data;
  });

  return Promise.all(orderPromises);
};

export const getOrderById = async (orderId: string): Promise<Order | null> => {
  const { data, error } = await supabase
    .from('orders')
    .select('*')
    .eq('id', orderId)
    .single();

  if (error) {
    console.error('Error fetching order:', error);
    return null;
  }

  return data;
};

export const updateOrderStatus = async (orderId: string, status: string): Promise<boolean> => {
  const { error } = await supabase
    .from('orders')
    .update({ status, updated_at: new Date().toISOString() })
    .eq('id', orderId);

  if (error) {
    console.error('Error updating order status:', error);
    return false;
  }

  return true;
};

export const getCustomerOrders = async (email: string): Promise<Order[]> => {
  const { data, error } = await supabase
    .from('orders')
    .select('*')
    .eq('customer_email', email)
    .order('created_at', { ascending: false });

  if (error) {
    console.error('Error fetching customer orders:', error);
    return [];
  }

  return data || [];
};

export const deleteOrder = async (orderId: string): Promise<boolean> => {
  const { error } = await supabase
    .from('orders')
    .delete()
    .eq('id', orderId);

  if (error) {
    console.error('Error deleting order:', error);
    return false;
  }

  return true;
};