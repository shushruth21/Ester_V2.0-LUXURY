import { Home, Search, Heart, ShoppingBag, User, LayoutDashboard } from "lucide-react";
import { Link, useLocation } from "react-router-dom";
import { cn } from "@/lib/utils";
import { useAuth } from "@/contexts/AuthContext";

const customerNavItems = [
  { icon: Home, label: "Home", href: "/home" },
  { icon: Search, label: "Search", href: "/categories" },
  { icon: Heart, label: "Wishlist", href: "/wishlist" },
  { icon: ShoppingBag, label: "Cart", href: "/cart" },
  { icon: User, label: "Profile", href: "/profile" },
];

export const MobileNavigation = () => {
  const location = useLocation();
  const { user, userType } = useAuth();

  // Staff users don't need mobile navigation for shopping
  if (userType === 'staff') {
    return null;
  }

  // Only show for customers
  const navItems = userType === 'customer' ? customerNavItems : [];

  // Don't render if no nav items (e.g., for staff or unauthenticated users)
  if (navItems.length === 0) {
    return null;
  }

  return (
    <nav className="fixed bottom-0 left-0 right-0 bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60 border-t border-border z-50 safe-area-bottom">
      <div className="flex items-center justify-around px-4 py-2">
        {navItems.map(({ icon: Icon, label, href }) => {
          const isActive = location.pathname === href;
          return (
            <Link
              key={href}
              to={href}
              className={cn(
                "flex flex-col items-center justify-center min-w-[60px] py-2 px-1 rounded-lg transition-colors touch-manipulation",
                isActive
                  ? "text-primary bg-primary/10"
                  : "text-muted-foreground hover:text-foreground"
              )}
            >
              <Icon className="h-5 w-5 mb-1" />
              <span className="text-xs font-medium">{label}</span>
            </Link>
          );
        })}
      </div>
    </nav>
  );
};