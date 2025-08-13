import { useAuth } from "@/contexts/AuthContext";
import { Navigate } from "react-router-dom";
import { ReactNode } from "react";

interface RoleProtectedRouteProps {
  children: ReactNode;
  allowedRoles: ('customer' | 'staff')[];
  redirectTo?: string;
}

export const RoleProtectedRoute = ({ 
  children, 
  allowedRoles, 
  redirectTo 
}: RoleProtectedRouteProps) => {
  const { user, userType, loading } = useAuth();

  // Show loading while determining user type
  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    );
  }

  // Not authenticated - redirect to auth page
  if (!user) {
    return <Navigate to="/auth" replace />;
  }

  // User type not determined yet or not allowed
  if (!userType || !allowedRoles.includes(userType)) {
    // Determine redirect path based on user type or fallback
    const defaultRedirect = userType === 'staff' ? '/staff-dashboard' : 
                           userType === 'customer' ? '/customer-dashboard' : 
                           '/auth';
    
    return <Navigate to={redirectTo || defaultRedirect} replace />;
  }

  return <>{children}</>;
};

// Convenience components for specific roles
export const CustomerOnlyRoute = ({ children }: { children: ReactNode }) => (
  <RoleProtectedRoute allowedRoles={['customer']} redirectTo="/staff-dashboard">
    {children}
  </RoleProtectedRoute>
);

export const StaffOnlyRoute = ({ children }: { children: ReactNode }) => (
  <RoleProtectedRoute allowedRoles={['staff']} redirectTo="/customer-dashboard">
    {children}
  </RoleProtectedRoute>
);