
import { Toaster } from "@/components/ui/toaster";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { TooltipProvider } from "@/components/ui/tooltip";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Routes, Route, useLocation, Navigate } from "react-router-dom";
import { AuthProvider, useAuth } from "@/contexts/AuthContext";
import { CartProvider } from "@/contexts/CartContext";
import { Welcome } from "./pages/Welcome";
import { Home } from "./pages/Home";
import { CategoryPage } from "./pages/CategoryPage";
import { AllCategoriesPage } from "./pages/AllCategoriesPage";
import { ModelConfiguratorPage } from "./pages/ModelConfiguratorPage";
import { ProfilePage } from "./pages/ProfilePage";
import { WishlistPage } from "./pages/WishlistPage";
import { CartPage } from "./pages/CartPage";
import { CheckoutPage } from "./pages/CheckoutPage";
import { VerifyOtpPage } from "./pages/VerifyOtpPage";
import { OrderVerificationPage } from "./pages/OrderVerificationPage";
import { AuthPage } from "./pages/AuthPage";
import { AdminImageManagerPage } from "./pages/AdminImageManagerPage";
import { StaffDashboard } from "./pages/StaffDashboard";
import { CustomerDashboard } from "./pages/CustomerDashboard";
import { OrderManagement } from "./components/OrderManagement";
import { MobileNavigation } from "./components/MobileNavigation";
import { CustomerOnlyRoute, StaffOnlyRoute } from "./components/RoleProtectedRoute";
import NotFound from "./pages/NotFound";

// Protected Route Component
const ProtectedRoute = ({ children }: { children: React.ReactNode }) => {
  const { user, loading } = useAuth();
  const location = useLocation();
  
  if (loading) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4"></div>
          <p className="text-muted-foreground">Loading...</p>
        </div>
      </div>
    );
  }
  
  if (!user) {
    return <Navigate to="/auth" state={{ from: location }} replace />;
  }
  
  return <>{children}</>;
};

// Smart redirect component for authenticated users
const AuthenticatedUserRedirect = () => {
  const { user, userType, loading } = useAuth();

  if (loading) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4"></div>
          <p className="text-muted-foreground">Loading...</p>
        </div>
      </div>
    );
  }

  if (!user) {
    return <Navigate to="/auth" replace />;
  }

  // Redirect based on user type
  if (userType === 'staff') {
    return <Navigate to="/staff-dashboard" replace />;
  } else if (userType === 'customer') {
    return <Navigate to="/customer-dashboard" replace />;
  }

  // Fallback to auth if user type unknown
  return <Navigate to="/auth" replace />;
};

const AppLayout = ({ children }: { children: React.ReactNode }) => {
  const location = useLocation();
  const showMobileNav = location.pathname !== "/auth";
  
  return (
    <div className="mobile-safe-area">
      <div className={showMobileNav ? "mobile-bottom-nav-padding" : ""}>
        {children}
      </div>
      {showMobileNav && <MobileNavigation />}
    </div>
  );
};

const queryClient = new QueryClient();

const App = () => (
  <QueryClientProvider client={queryClient}>
    <TooltipProvider>
      <Toaster />
      <Sonner />
      <BrowserRouter>
        <AuthProvider>
          <CartProvider>
            <AppLayout>
              <Routes>
                <Route path="/auth" element={<AuthPage />} />
                <Route path="/home" element={<Home />} />
                <Route path="/categories" element={<AllCategoriesPage />} />
                <Route path="/category/:slug" element={<CategoryPage />} />
                <Route path="/model/:slug/configure" element={<ModelConfiguratorPage />} />
                
                {/* Customer-only routes */}
                <Route path="/wishlist" element={
                  <CustomerOnlyRoute>
                    <WishlistPage />
                  </CustomerOnlyRoute>
                } />
                <Route path="/cart" element={
                  <CustomerOnlyRoute>
                    <CartPage />
                  </CustomerOnlyRoute>
                } />
                <Route path="/checkout" element={
                  <CustomerOnlyRoute>
                    <CheckoutPage />
                  </CustomerOnlyRoute>
                } />
                <Route path="/verify-otp" element={
                  <CustomerOnlyRoute>
                    <VerifyOtpPage />
                  </CustomerOnlyRoute>
                } />
                <Route path="/order-verification" element={<OrderVerificationPage />} />
                <Route path="/customer-dashboard" element={
                  <CustomerOnlyRoute>
                    <CustomerDashboard />
                  </CustomerOnlyRoute>
                } />
                
                {/* Staff-only routes */}
                <Route path="/staff-dashboard" element={
                  <StaffOnlyRoute>
                    <StaffDashboard />
                  </StaffOnlyRoute>
                } />
                <Route path="/admin/images" element={
                  <StaffOnlyRoute>
                    <AdminImageManagerPage />
                  </StaffOnlyRoute>
                } />
                <Route path="/orders" element={
                  <StaffOnlyRoute>
                    <OrderManagement />
                  </StaffOnlyRoute>
                } />
                
                {/* Shared protected routes */}
                <Route path="/profile" element={
                  <ProtectedRoute>
                    <ProfilePage />
                  </ProtectedRoute>
                } />
                
                {/* Root redirect based on auth status */}
                <Route path="/" element={<AuthenticatedUserRedirect />} />
                {/* ADD ALL CUSTOM ROUTES ABOVE THE CATCH-ALL "*" ROUTE */}
                <Route path="*" element={<NotFound />} />
              </Routes>
            </AppLayout>
          </CartProvider>
        </AuthProvider>
      </BrowserRouter>
    </TooltipProvider>
  </QueryClientProvider>
);

export default App;
