export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instanciate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "12.2.12 (cd3cf9e)"
  }
  public: {
    Tables: {
      attribute_types: {
        Row: {
          created_at: string
          description: string | null
          display_name: string
          id: string
          input_type: string
          name: string
          sort_order: number
          updated_at: string
        }
        Insert: {
          created_at?: string
          description?: string | null
          display_name: string
          id?: string
          input_type?: string
          name: string
          sort_order?: number
          updated_at?: string
        }
        Update: {
          created_at?: string
          description?: string | null
          display_name?: string
          id?: string
          input_type?: string
          name?: string
          sort_order?: number
          updated_at?: string
        }
        Relationships: []
      }
      attribute_values: {
        Row: {
          attribute_type_id: string
          created_at: string
          display_name: string
          hex_color: string | null
          id: string
          image_url: string | null
          price_modifier: number
          sort_order: number
          updated_at: string
          value: string
        }
        Insert: {
          attribute_type_id: string
          created_at?: string
          display_name: string
          hex_color?: string | null
          id?: string
          image_url?: string | null
          price_modifier?: number
          sort_order?: number
          updated_at?: string
          value: string
        }
        Update: {
          attribute_type_id?: string
          created_at?: string
          display_name?: string
          hex_color?: string | null
          id?: string
          image_url?: string | null
          price_modifier?: number
          sort_order?: number
          updated_at?: string
          value?: string
        }
        Relationships: [
          {
            foreignKeyName: "attribute_values_attribute_type_id_fkey"
            columns: ["attribute_type_id"]
            isOneToOne: false
            referencedRelation: "attribute_types"
            referencedColumns: ["id"]
          },
        ]
      }
      categories: {
        Row: {
          created_at: string
          description: string | null
          id: string
          image_url: string | null
          name: string
          slug: string
          updated_at: string
        }
        Insert: {
          created_at?: string
          description?: string | null
          id?: string
          image_url?: string | null
          name: string
          slug: string
          updated_at?: string
        }
        Update: {
          created_at?: string
          description?: string | null
          id?: string
          image_url?: string | null
          name?: string
          slug?: string
          updated_at?: string
        }
        Relationships: []
      }
      customers: {
        Row: {
          created_at: string
          email: string
          full_name: string
          id: string
          mobile: string | null
          updated_at: string
          user_id: string | null
        }
        Insert: {
          created_at?: string
          email: string
          full_name: string
          id?: string
          mobile?: string | null
          updated_at?: string
          user_id?: string | null
        }
        Update: {
          created_at?: string
          email?: string
          full_name?: string
          id?: string
          mobile?: string | null
          updated_at?: string
          user_id?: string | null
        }
        Relationships: []
      }
      furniture_models: {
        Row: {
          base_price: number
          category_id: string
          created_at: string
          default_image_url: string | null
          description: string | null
          id: string
          is_featured: boolean
          name: string
          slug: string
          updated_at: string
        }
        Insert: {
          base_price?: number
          category_id: string
          created_at?: string
          default_image_url?: string | null
          description?: string | null
          id?: string
          is_featured?: boolean
          name: string
          slug: string
          updated_at?: string
        }
        Update: {
          base_price?: number
          category_id?: string
          created_at?: string
          default_image_url?: string | null
          description?: string | null
          id?: string
          is_featured?: boolean
          name?: string
          slug?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "furniture_models_category_id_fkey"
            columns: ["category_id"]
            isOneToOne: false
            referencedRelation: "categories"
            referencedColumns: ["id"]
          },
        ]
      }
      image_upload_sessions: {
        Row: {
          completed_files: number
          created_at: string
          id: string
          metadata: Json | null
          status: string
          total_files: number
          updated_at: string
          upload_session_id: string
          user_id: string
        }
        Insert: {
          completed_files?: number
          created_at?: string
          id?: string
          metadata?: Json | null
          status?: string
          total_files?: number
          updated_at?: string
          upload_session_id: string
          user_id: string
        }
        Update: {
          completed_files?: number
          created_at?: string
          id?: string
          metadata?: Json | null
          status?: string
          total_files?: number
          updated_at?: string
          upload_session_id?: string
          user_id?: string
        }
        Relationships: []
      }
      images: {
        Row: {
          alt_text: string | null
          category_id: string | null
          created_at: string
          display_order: number
          file_size: number | null
          filename: string
          id: string
          is_primary: boolean
          mime_type: string | null
          model_id: string | null
          storage_path: string
          updated_at: string
        }
        Insert: {
          alt_text?: string | null
          category_id?: string | null
          created_at?: string
          display_order?: number
          file_size?: number | null
          filename: string
          id?: string
          is_primary?: boolean
          mime_type?: string | null
          model_id?: string | null
          storage_path: string
          updated_at?: string
        }
        Update: {
          alt_text?: string | null
          category_id?: string | null
          created_at?: string
          display_order?: number
          file_size?: number | null
          filename?: string
          id?: string
          is_primary?: boolean
          mime_type?: string | null
          model_id?: string | null
          storage_path?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "images_category_id_fkey"
            columns: ["category_id"]
            isOneToOne: false
            referencedRelation: "categories"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "images_model_id_fkey"
            columns: ["model_id"]
            isOneToOne: false
            referencedRelation: "furniture_models"
            referencedColumns: ["id"]
          },
        ]
      }
      invoices: {
        Row: {
          amount: number
          authorized_at: string | null
          authorized_email: string | null
          created_at: string
          id: string
          invoice_number: string
          order_id: string
          otp_code: string | null
          otp_expires_at: string | null
          status: string
          updated_at: string
        }
        Insert: {
          amount: number
          authorized_at?: string | null
          authorized_email?: string | null
          created_at?: string
          id?: string
          invoice_number: string
          order_id: string
          otp_code?: string | null
          otp_expires_at?: string | null
          status?: string
          updated_at?: string
        }
        Update: {
          amount?: number
          authorized_at?: string | null
          authorized_email?: string | null
          created_at?: string
          id?: string
          invoice_number?: string
          order_id?: string
          otp_code?: string | null
          otp_expires_at?: string | null
          status?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "fk_invoices_order_id"
            columns: ["order_id"]
            isOneToOne: false
            referencedRelation: "orders"
            referencedColumns: ["id"]
          },
        ]
      }
      job_cards: {
        Row: {
          actual_completion_date: string | null
          assigned_staff_id: string | null
          configuration_details: Json
          created_at: string
          customer_details: Json
          estimated_completion_date: string | null
          id: string
          invoice_id: string | null
          job_number: string
          notes: string | null
          order_id: string
          priority: string
          product_details: Json
          status: string
          updated_at: string
        }
        Insert: {
          actual_completion_date?: string | null
          assigned_staff_id?: string | null
          configuration_details?: Json
          created_at?: string
          customer_details?: Json
          estimated_completion_date?: string | null
          id?: string
          invoice_id?: string | null
          job_number: string
          notes?: string | null
          order_id: string
          priority?: string
          product_details?: Json
          status?: string
          updated_at?: string
        }
        Update: {
          actual_completion_date?: string | null
          assigned_staff_id?: string | null
          configuration_details?: Json
          created_at?: string
          customer_details?: Json
          estimated_completion_date?: string | null
          id?: string
          invoice_id?: string | null
          job_number?: string
          notes?: string | null
          order_id?: string
          priority?: string
          product_details?: Json
          status?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "fk_job_cards_invoice_id"
            columns: ["invoice_id"]
            isOneToOne: false
            referencedRelation: "invoices"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fk_job_cards_order_id"
            columns: ["order_id"]
            isOneToOne: false
            referencedRelation: "orders"
            referencedColumns: ["id"]
          },
        ]
      }
      model_attributes: {
        Row: {
          attribute_type_id: string
          created_at: string
          default_value_id: string | null
          id: string
          is_required: boolean
          model_id: string
          updated_at: string
        }
        Insert: {
          attribute_type_id: string
          created_at?: string
          default_value_id?: string | null
          id?: string
          is_required?: boolean
          model_id: string
          updated_at?: string
        }
        Update: {
          attribute_type_id?: string
          created_at?: string
          default_value_id?: string | null
          id?: string
          is_required?: boolean
          model_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "model_attributes_attribute_type_id_fkey"
            columns: ["attribute_type_id"]
            isOneToOne: false
            referencedRelation: "attribute_types"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "model_attributes_default_value_id_fkey"
            columns: ["default_value_id"]
            isOneToOne: false
            referencedRelation: "attribute_values"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "model_attributes_model_id_fkey"
            columns: ["model_id"]
            isOneToOne: false
            referencedRelation: "furniture_models"
            referencedColumns: ["id"]
          },
        ]
      }
      order_verifications: {
        Row: {
          created_at: string
          id: string
          ip_address: string | null
          order_id: string
          user_agent: string | null
          verification_code: string
          verification_email: string
          verified_at: string
        }
        Insert: {
          created_at?: string
          id?: string
          ip_address?: string | null
          order_id: string
          user_agent?: string | null
          verification_code: string
          verification_email: string
          verified_at?: string
        }
        Update: {
          created_at?: string
          id?: string
          ip_address?: string | null
          order_id?: string
          user_agent?: string | null
          verification_code?: string
          verification_email?: string
          verified_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "order_verifications_order_id_fkey"
            columns: ["order_id"]
            isOneToOne: false
            referencedRelation: "orders"
            referencedColumns: ["id"]
          },
        ]
      }
      orders: {
        Row: {
          configuration: Json
          created_at: string
          customer_email: string
          customer_name: string | null
          customer_phone: string | null
          id: string
          model_id: string
          remarks: string | null
          status: string
          total_price: number
          updated_at: string
          verification_code: string | null
          verification_email: string | null
          verified_at: string | null
        }
        Insert: {
          configuration?: Json
          created_at?: string
          customer_email: string
          customer_name?: string | null
          customer_phone?: string | null
          id?: string
          model_id: string
          remarks?: string | null
          status?: string
          total_price?: number
          updated_at?: string
          verification_code?: string | null
          verification_email?: string | null
          verified_at?: string | null
        }
        Update: {
          configuration?: Json
          created_at?: string
          customer_email?: string
          customer_name?: string | null
          customer_phone?: string | null
          id?: string
          model_id?: string
          remarks?: string | null
          status?: string
          total_price?: number
          updated_at?: string
          verification_code?: string | null
          verification_email?: string | null
          verified_at?: string | null
        }
        Relationships: []
      }
      otp_codes: {
        Row: {
          attempts: number
          created_at: string
          email: string
          expires_at: string
          id: string
          is_used: boolean
          otp_code: string
          verified_at: string | null
        }
        Insert: {
          attempts?: number
          created_at?: string
          email: string
          expires_at: string
          id?: string
          is_used?: boolean
          otp_code: string
          verified_at?: string | null
        }
        Update: {
          attempts?: number
          created_at?: string
          email?: string
          expires_at?: string
          id?: string
          is_used?: boolean
          otp_code?: string
          verified_at?: string | null
        }
        Relationships: []
      }
      profiles: {
        Row: {
          created_at: string
          full_name: string | null
          id: string
          mobile: string | null
          updated_at: string
          user_id: string
        }
        Insert: {
          created_at?: string
          full_name?: string | null
          id?: string
          mobile?: string | null
          updated_at?: string
          user_id: string
        }
        Update: {
          created_at?: string
          full_name?: string | null
          id?: string
          mobile?: string | null
          updated_at?: string
          user_id?: string
        }
        Relationships: []
      }
      staff: {
        Row: {
          created_at: string
          department: string | null
          email: string
          full_name: string
          id: string
          password_hash: string
          updated_at: string
          user_id: string | null
        }
        Insert: {
          created_at?: string
          department?: string | null
          email: string
          full_name: string
          id?: string
          password_hash: string
          updated_at?: string
          user_id?: string | null
        }
        Update: {
          created_at?: string
          department?: string | null
          email?: string
          full_name?: string
          id?: string
          password_hash?: string
          updated_at?: string
          user_id?: string | null
        }
        Relationships: []
      }
      user_roles: {
        Row: {
          created_at: string
          id: string
          role: Database["public"]["Enums"]["app_role"]
          user_id: string
        }
        Insert: {
          created_at?: string
          id?: string
          role: Database["public"]["Enums"]["app_role"]
          user_id: string
        }
        Update: {
          created_at?: string
          id?: string
          role?: Database["public"]["Enums"]["app_role"]
          user_id?: string
        }
        Relationships: []
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      cleanup_expired_otp_codes: {
        Args: Record<PropertyKey, never>
        Returns: undefined
      }
      has_role: {
        Args: {
          _user_id: string
          _role: Database["public"]["Enums"]["app_role"]
        }
        Returns: boolean
      }
    }
    Enums: {
      app_role: "customer" | "staff"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {
      app_role: ["customer", "staff"],
    },
  },
} as const
