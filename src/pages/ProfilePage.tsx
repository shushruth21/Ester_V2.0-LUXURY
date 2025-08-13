import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { User, Settings, Heart, ShoppingBag, Phone, Mail, MapPin, LogOut, Image } from "lucide-react";
import { useAuth } from "@/contexts/AuthContext";
import { Link } from "react-router-dom";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";

export const ProfilePage = () => {
  const { user, userType, signOut } = useAuth();
  const [userProfile, setUserProfile] = useState<any>(null);

  useEffect(() => {
    const fetchUserProfile = async () => {
      if (!user?.id) return;

      // Try to get from profiles table first
      const { data: profile } = await supabase
        .from('profiles')
        .select('*')
        .eq('user_id', user.id)
        .single();

      if (profile) {
        setUserProfile(profile);
      } else {
        // Fallback to customers table
        const { data: customer } = await supabase
          .from('customers')
          .select('*')
          .eq('user_id', user.id)
          .single();
        
        setUserProfile(customer);
      }
    };

    fetchUserProfile();
  }, [user?.id]);

  const handleSignOut = async () => {
    await signOut();
  };
  return (
    <div className="min-h-screen bg-background">
      <main className="px-4 py-6">
        <div className="space-y-6">
          {/* Profile Header */}
          <Card>
            <CardContent className="p-6">
              <div className="flex flex-col items-center text-center space-y-4">
                <Avatar className="h-20 w-20">
                  <AvatarImage src="" alt="Profile" />
                  <AvatarFallback className="text-lg">
                    <User className="h-8 w-8" />
                  </AvatarFallback>
                </Avatar>
                <div>
                  <h1 className="text-xl font-bold text-foreground">
                    {userProfile?.full_name || user?.email || "User"}
                  </h1>
                  <p className="text-sm text-muted-foreground">
                    {userType === 'staff' ? 'Staff Member' : 'Customer'}
                  </p>
                  <Badge variant="secondary" className="mt-2">
                    {userType === 'staff' ? 'Staff Access' : 'Customer'}
                  </Badge>
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Contact Information */}
          <Card>
            <CardHeader>
              <CardTitle className="text-lg">Contact Information</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="flex items-center space-x-3">
                <Mail className="h-4 w-4 text-muted-foreground" />
                <span className="text-sm">{user?.email || "No email"}</span>
              </div>
              <div className="flex items-center space-x-3">
                <Phone className="h-4 w-4 text-muted-foreground" />
                <span className="text-sm">{userProfile?.mobile || userProfile?.phone || "No phone number"}</span>
              </div>
              <div className="flex items-center space-x-3">
                <User className="h-4 w-4 text-muted-foreground" />
                <span className="text-sm">{userProfile?.full_name || "No name provided"}</span>
              </div>
            </CardContent>
          </Card>

          {/* Quick Actions */}
          <Card>
            <CardHeader>
              <CardTitle className="text-lg">Quick Actions</CardTitle>
            </CardHeader>
            <CardContent className="space-y-3">
              <Button variant="outline" className="w-full justify-start">
                <Heart className="h-4 w-4 mr-3" />
                My Wishlist
              </Button>
              <Link to="/customer-dashboard">
                <Button variant="outline" className="w-full justify-start">
                  <ShoppingBag className="h-4 w-4 mr-3" />
                  Order History
                </Button>
              </Link>
              <Button variant="outline" className="w-full justify-start">
                <Settings className="h-4 w-4 mr-3" />
                Account Settings
              </Button>
              {userType === 'staff' && (
                <Link to="/admin/images">
                  <Button variant="outline" className="w-full justify-start">
                    <Image className="h-4 w-4 mr-3" />
                    Manage Images
                  </Button>
                </Link>
              )}
            </CardContent>
          </Card>

          {/* Account Actions */}
          <div className="space-y-3">
            <Button className="w-full">
              Edit Profile
            </Button>
            <Button variant="outline" className="w-full" onClick={handleSignOut}>
              <LogOut className="h-4 w-4 mr-2" />
              Sign Out
            </Button>
          </div>
        </div>
      </main>
    </div>
  );
};