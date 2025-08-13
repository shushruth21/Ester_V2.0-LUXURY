import { useState, useEffect } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { useAuth } from "@/contexts/AuthContext";
import { Eye, EyeOff, ArrowRight, Users, Shield } from "lucide-react";
import { useNavigate } from "react-router-dom";

export const AuthPage = () => {
  const [customerMode, setCustomerMode] = useState<'login' | 'register'>('login');
  const [customerData, setCustomerData] = useState({
    email: "",
    password: "",
    fullName: "",
    mobile: ""
  });
  const [staffData, setStaffData] = useState({
    email: "",
    password: ""
  });
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [success, setSuccess] = useState("");
  
  const { signInCustomer, signInStaff, signUpCustomer, user, userType } = useAuth();
  const navigate = useNavigate();

  // Redirect if already authenticated
  useEffect(() => {
    if (user && userType) {
      if (userType === 'staff') {
        navigate("/staff-dashboard");
      } else {
        navigate("/customer-dashboard");
      }
    }
  }, [user, userType, navigate]);

  const handleGuestAccess = () => {
    navigate("/home");
  };

  const handleCustomerSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    setSuccess("");
    setLoading(true);

    if (customerData.password.length < 6) {
      setError("Password must be at least 6 characters");
      setLoading(false);
      return;
    }

    try {
      if (customerMode === 'register') {
        if (!customerData.fullName.trim()) {
          setError("Full name is required");
          setLoading(false);
          return;
        }

        const { error } = await signUpCustomer(
          customerData.email, 
          customerData.password, 
          customerData.fullName,
          customerData.mobile
        );
        
        if (error) {
          setError(error.message || "Failed to create account");
        } else {
          setSuccess("Account created successfully! Please check your email to verify your account.");
          // Reset form
          setCustomerData({ email: "", password: "", fullName: "", mobile: "" });
          setCustomerMode('login');
        }
      } else {
        const { error } = await signInCustomer(customerData.email, customerData.password);
        
        if (error) {
          setError(error.message || "Failed to sign in");
        } else {
          setSuccess("Login successful! Redirecting...");
          setTimeout(() => navigate("/customer-dashboard"), 1500);
        }
      }
    } catch (err) {
      setError("An unexpected error occurred");
    } finally {
      setLoading(false);
    }
  };

  const handleStaffSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    setSuccess("");
    setLoading(true);

    if (staffData.email !== 'staff@estre.in') {
      setError("Invalid staff email. Only staff@estre.in is allowed.");
      setLoading(false);
      return;
    }

    if (staffData.password !== 'staff123') {
      setError("Invalid staff credentials. Please check your password.");
      setLoading(false);
      return;
    }

    try {
      const { error } = await signInStaff(staffData.email, staffData.password);
      
      if (error) {
        setError("Invalid staff credentials. Please check your credentials.");
      } else {
        setSuccess("Staff login successful! Redirecting...");
        setTimeout(() => navigate("/staff-dashboard"), 1500);
      }
    } catch (err) {
      setError("An unexpected error occurred");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex">
      {/* Left Side - Luxury Background */}
      <div className="hidden lg:flex lg:w-1/2 relative bg-gradient-to-br from-primary-dark to-primary overflow-hidden">
        <div 
          className="absolute inset-0 bg-cover bg-center"
          style={{
            backgroundImage: "url('https://images.unsplash.com/photo-1470813740244-df37b8c1edcb?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80')"
          }}
        >
          <div className="absolute inset-0 bg-primary/40"></div>
        </div>
        
        <div className="relative z-10 flex flex-col justify-center px-12 py-16 text-white">
          <div className="max-w-lg">
            <h1 className="text-6xl font-luxury font-bold mb-6">Estre</h1>
            <h2 className="text-3xl font-display font-medium mb-8">Where Luxury Meets Comfort</h2>
            <p className="text-lg leading-relaxed text-white/90">
              Discover our curated collection of premium furniture, 
              crafted with precision and designed for the modern 
              lifestyle. Transform your space into a sanctuary of elegance 
              and comfort.
            </p>
          </div>
        </div>
      </div>

      {/* Right Side - Auth Form */}
      <div className="flex-1 flex items-center justify-center px-6 py-12 bg-background">
        <div className="w-full max-w-md space-y-8">
          
          {/* Guest Access Button */}
          <Card className="border-0 shadow-sm bg-gradient-to-r from-primary/5 to-accent/5">
            <CardContent className="pt-6">
              <Button 
                onClick={handleGuestAccess} 
                className="w-full h-12 bg-primary hover:bg-primary-dark text-white font-medium"
              >
                Continue as Guest
                <ArrowRight className="ml-2 h-4 w-4" />
              </Button>
              <p className="text-center text-sm text-muted-foreground mt-2">
                Explore our collection without signing in
              </p>
            </CardContent>
          </Card>

          {/* Main Auth Card */}
          <Card className="border-0 shadow-lg">
            <CardHeader className="text-center pb-4">
              <CardTitle className="text-2xl font-display text-primary mb-2">
                Welcome to Estre
              </CardTitle>
              <p className="text-muted-foreground">Choose your access type</p>
            </CardHeader>

            <CardContent className="space-y-6">
              
              {error && (
                <Alert variant="destructive">
                  <AlertDescription>{error}</AlertDescription>
                </Alert>
              )}

              {success && (
                <Alert className="border-green-200 bg-green-50">
                  <AlertDescription className="text-green-800">{success}</AlertDescription>
                </Alert>
              )}

              <Tabs defaultValue="customer" className="w-full">
                <TabsList className="grid w-full grid-cols-2">
                  <TabsTrigger value="customer" className="flex items-center gap-2">
                    <Users className="h-4 w-4" />
                    Customer
                  </TabsTrigger>
                  <TabsTrigger value="staff" className="flex items-center gap-2">
                    <Shield className="h-4 w-4" />
                    Staff
                  </TabsTrigger>
                </TabsList>

                {/* Customer Tab */}
                <TabsContent value="customer" className="space-y-4">
                  <div className="flex bg-muted rounded-lg p-1">
                    <button
                      onClick={() => setCustomerMode('login')}
                      className={`flex-1 py-2 px-4 rounded-md text-sm font-medium transition-all ${
                        customerMode === 'login' 
                          ? 'bg-background text-foreground shadow-sm' 
                          : 'text-muted-foreground hover:text-foreground'
                      }`}
                    >
                      Sign In
                    </button>
                    <button
                      onClick={() => setCustomerMode('register')}
                      className={`flex-1 py-2 px-4 rounded-md text-sm font-medium transition-all ${
                        customerMode === 'register' 
                          ? 'bg-background text-foreground shadow-sm' 
                          : 'text-muted-foreground hover:text-foreground'
                      }`}
                    >
                      Register
                    </button>
                  </div>

                  <form onSubmit={handleCustomerSubmit} className="space-y-4">
                    {customerMode === 'register' && (
                      <>
                        <div className="space-y-2">
                          <Label htmlFor="fullName">Full Name *</Label>
                          <Input
                            id="fullName"
                            placeholder="Enter your full name"
                            value={customerData.fullName}
                            onChange={(e) => setCustomerData({...customerData, fullName: e.target.value})}
                            required
                            disabled={loading}
                          />
                        </div>
                        <div className="space-y-2">
                          <Label htmlFor="mobile">Mobile Number</Label>
                          <Input
                            id="mobile"
                            placeholder="Enter your mobile number"
                            value={customerData.mobile}
                            onChange={(e) => setCustomerData({...customerData, mobile: e.target.value})}
                            disabled={loading}
                          />
                        </div>
                      </>
                    )}
                    
                    <div className="space-y-2">
                      <Label htmlFor="customerEmail">Email *</Label>
                      <Input
                        id="customerEmail"
                        type="email"
                        placeholder="Enter your email"
                        value={customerData.email}
                        onChange={(e) => setCustomerData({...customerData, email: e.target.value})}
                        required
                        disabled={loading}
                      />
                    </div>

                    <div className="space-y-2">
                      <Label htmlFor="customerPassword">Password *</Label>
                      <div className="relative">
                        <Input
                          id="customerPassword"
                          type={showPassword ? "text" : "password"}
                          placeholder="Enter your password"
                          value={customerData.password}
                          onChange={(e) => setCustomerData({...customerData, password: e.target.value})}
                          required
                          disabled={loading}
                          className="pr-10"
                        />
                        <Button
                          type="button"
                          variant="ghost"
                          size="sm"
                          className="absolute right-2 top-1/2 -translate-y-1/2 h-7 w-7 p-0"
                          onClick={() => setShowPassword(!showPassword)}
                          disabled={loading}
                        >
                          {showPassword ? 
                            <EyeOff className="h-4 w-4 text-muted-foreground" /> : 
                            <Eye className="h-4 w-4 text-muted-foreground" />
                          }
                        </Button>
                      </div>
                      {customerMode === 'register' && (
                        <p className="text-xs text-muted-foreground">
                          Password must be at least 6 characters
                        </p>
                      )}
                    </div>

                    <Button 
                      type="submit" 
                      className="w-full h-11 bg-primary hover:bg-primary-dark text-white font-medium" 
                      disabled={loading}
                    >
                      {loading ? "Please wait..." : customerMode === 'register' ? "Create Account" : "Sign In"}
                    </Button>
                  </form>
                </TabsContent>

                {/* Staff Tab */}
                <TabsContent value="staff" className="space-y-4">
                  <div className="bg-accent/10 border border-accent/20 rounded-lg p-4">
                    <p className="text-sm text-muted-foreground text-center">
                      Staff access is restricted to authorized personnel only
                    </p>
                  </div>

                  <form onSubmit={handleStaffSubmit} className="space-y-4">
                    <div className="space-y-2">
                      <Label htmlFor="staffEmail">Staff Email</Label>
                      <Input
                        id="staffEmail"
                        type="email"
                        placeholder="staff@estre.in"
                        value={staffData.email}
                        onChange={(e) => setStaffData({...staffData, email: e.target.value})}
                        required
                        disabled={loading}
                      />
                    </div>

                    <div className="space-y-2">
                      <Label htmlFor="staffPassword">Password</Label>
                      <div className="relative">
                        <Input
                          id="staffPassword"
                          type={showPassword ? "text" : "password"}
                          placeholder="Enter staff password"
                          value={staffData.password}
                          onChange={(e) => setStaffData({...staffData, password: e.target.value})}
                          required
                          disabled={loading}
                          className="pr-10"
                        />
                        <Button
                          type="button"
                          variant="ghost"
                          size="sm"
                          className="absolute right-2 top-1/2 -translate-y-1/2 h-7 w-7 p-0"
                          onClick={() => setShowPassword(!showPassword)}
                          disabled={loading}
                        >
                          {showPassword ? 
                            <EyeOff className="h-4 w-4 text-muted-foreground" /> : 
                            <Eye className="h-4 w-4 text-muted-foreground" />
                          }
                        </Button>
                      </div>
                    </div>

                    <Button 
                      type="submit" 
                      className="w-full h-11 bg-accent hover:bg-accent/90 text-accent-foreground font-medium" 
                      disabled={loading}
                    >
                      {loading ? "Authenticating..." : "Staff Sign In"}
                    </Button>
                  </form>
                </TabsContent>
              </Tabs>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
};