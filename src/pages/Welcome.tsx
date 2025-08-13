import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Eye, EyeOff, Mail, Phone, Lock, ArrowRight } from "lucide-react";
import { useNavigate, Link } from "react-router-dom";
import heroImage from "@/assets/showroom-hero.jpg";

export const Welcome = () => {
  const [showPassword, setShowPassword] = useState(false);
  const navigate = useNavigate();

  const handleContinueAsGuest = () => {
    navigate("/home");
  };

  return (
    <div className="min-h-screen relative overflow-hidden">
      {/* Background */}
      <div
        className="absolute inset-0 bg-cover bg-center"
        style={{ backgroundImage: `url(${heroImage})` }}
      >
        <div className="absolute inset-0 bg-gradient-to-br from-primary/80 via-primary/60 to-primary-dark/90" />
      </div>

      {/* Content */}
      <div className="relative z-10 min-h-screen flex items-center justify-center p-4">
        <div className="w-full max-w-6xl grid lg:grid-cols-2 gap-12 items-center">
          {/* Brand Section */}
          <div className="text-center lg:text-left animate-fade-up">
            <h1 className="text-6xl md:text-8xl font-display font-bold text-white mb-6">
              Estre
            </h1>
            <p className="text-2xl md:text-3xl text-white/90 mb-8 leading-relaxed">
              Where Luxury Meets Comfort
            </p>
            <p className="text-lg text-white/80 max-w-lg mx-auto lg:mx-0 leading-relaxed">
              Discover our curated collection of premium furniture, crafted with precision 
              and designed for the modern lifestyle. Transform your space into a sanctuary 
              of elegance and comfort.
            </p>
          </div>

          {/* Login/Signup Card */}
          <div className="animate-slide-in">
            <Card className="bg-white/95 backdrop-blur shadow-elegant border-0">
              <CardHeader className="text-center pb-4">
                <CardTitle className="text-2xl font-display text-primary">
                  Welcome to Estre
                </CardTitle>
                <CardDescription className="text-muted-foreground">
                  Start your luxury furniture journey
                </CardDescription>
              </CardHeader>
              
              <CardContent className="space-y-6">
                {/* Quick Access */}
                <div className="space-y-3">
                  <Button 
                    size="lg" 
                    variant="luxury" 
                    className="w-full group"
                    onClick={handleContinueAsGuest}
                  >
                    Continue as Guest
                    <ArrowRight className="h-4 w-4 group-hover:translate-x-1 transition-transform" />
                  </Button>
                  
                  <div className="relative">
                    <div className="absolute inset-0 flex items-center">
                      <span className="w-full border-t border-border" />
                    </div>
                    <div className="relative flex justify-center text-xs uppercase">
                      <span className="bg-background px-2 text-muted-foreground">
                        Or sign in
                      </span>
                    </div>
                  </div>
                </div>

                {/* Login/Signup Tabs */}
                <Tabs defaultValue="login" className="w-full">
                  <TabsList className="grid w-full grid-cols-2">
                    <TabsTrigger value="login">Login</TabsTrigger>
                    <TabsTrigger value="signup">Sign Up</TabsTrigger>
                  </TabsList>
                  
                  <TabsContent value="login" className="space-y-4 mt-6">
                    <div className="space-y-4">
                      <div className="relative">
                        <Mail className="absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground h-4 w-4" />
                        <Input
                          placeholder="Email or Mobile"
                          className="pl-10"
                        />
                      </div>
                      
                      <div className="relative">
                        <Lock className="absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground h-4 w-4" />
                        <Input
                          type={showPassword ? "text" : "password"}
                          placeholder="Password"
                          className="pl-10 pr-10"
                        />
                        <button
                          type="button"
                          onClick={() => setShowPassword(!showPassword)}
                          className="absolute right-3 top-1/2 transform -translate-y-1/2 text-muted-foreground hover:text-foreground"
                        >
                          {showPassword ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                        </button>
                      </div>
                      
                      <div className="flex items-center justify-between text-sm">
                        <label className="flex items-center space-x-2 cursor-pointer">
                          <input type="checkbox" className="rounded border-border" />
                          <span className="text-muted-foreground">Remember me</span>
                        </label>
                        <a href="#" className="text-primary hover:underline">
                          Forgot Password?
                        </a>
                      </div>
                      
                      <Button size="lg" variant="luxury" className="w-full">
                        Sign In
                      </Button>
                    </div>
                  </TabsContent>
                  
                  <TabsContent value="signup" className="space-y-4 mt-6">
                    <div className="space-y-4">
                      <Input placeholder="Full Name" />
                      
                      <div className="relative">
                        <Mail className="absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground h-4 w-4" />
                        <Input
                          placeholder="Email"
                          className="pl-10"
                        />
                      </div>
                      
                      <div className="relative">
                        <Phone className="absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground h-4 w-4" />
                        <Input
                          placeholder="Mobile Number"
                          className="pl-10"
                        />
                      </div>
                      
                      <div className="relative">
                        <Lock className="absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground h-4 w-4" />
                        <Input
                          type={showPassword ? "text" : "password"}
                          placeholder="Create Password"
                          className="pl-10 pr-10"
                        />
                        <button
                          type="button"
                          onClick={() => setShowPassword(!showPassword)}
                          className="absolute right-3 top-1/2 transform -translate-y-1/2 text-muted-foreground hover:text-foreground"
                        >
                          {showPassword ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                        </button>
                      </div>
                      
                      <Button size="lg" variant="luxury" className="w-full">
                        Create Account
                      </Button>
                      
                      <p className="text-xs text-center text-muted-foreground">
                        By signing up, you agree to our{" "}
                        <a href="#" className="text-primary hover:underline">
                          Terms of Service
                        </a>{" "}
                        and{" "}
                        <a href="#" className="text-primary hover:underline">
                          Privacy Policy
                        </a>
                      </p>
                    </div>
                  </TabsContent>
                </Tabs>

                {/* Staff Login */}
                <div className="pt-4 border-t border-border">
                  <Link to="/staff-dashboard">
                    <Button variant="outline" size="sm" className="w-full text-xs">
                      Staff Login
                    </Button>
                  </Link>
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    </div>
  );
};