import { Shield, Truck, Headphones, Award, Recycle, Home } from "lucide-react";

const features = [
  {
    icon: Shield,
    title: "Luxury Guarantee",
    description: "Premium quality materials with lifetime warranty on craftsmanship"
  },
  {
    icon: Truck,
    title: "Free Delivery",
    description: "Complimentary white-glove delivery and setup across India"
  },
  {
    icon: Headphones,
    title: "24/7 Support",
    description: "Dedicated customer service team available round the clock"
  },
  {
    icon: Award,
    title: "Award Winning",
    description: "Recognized for design excellence and customer satisfaction"
  },
  {
    icon: Recycle,
    title: "Eco-Friendly",
    description: "Sustainably sourced materials and environmentally conscious production"
  },
  {
    icon: Home,
    title: "Home Consultation",
    description: "Free interior design consultation and space planning services"
  }
];

export const Features = () => {
  return (
    <section className="py-20 bg-background">
      <div className="container mx-auto px-4">
        <div className="text-center mb-16">
          <h2 className="text-4xl md:text-5xl font-display font-bold text-gradient-primary mb-4">
            The Estre Promise
          </h2>
          <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
            Experience luxury furniture shopping with unmatched service and quality assurance
          </p>
        </div>

        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
          {features.map((feature, index) => (
            <div
              key={index}
              className="group p-8 rounded-xl border border-border hover:border-primary/30 transition-all duration-300 hover:shadow-card"
            >
              <div className="flex items-center mb-4">
                <div className="p-3 rounded-lg bg-gradient-primary">
                  <feature.icon className="h-6 w-6 text-primary-foreground" />
                </div>
                <h3 className="text-xl font-display font-semibold text-primary ml-4">
                  {feature.title}
                </h3>
              </div>
              <p className="text-muted-foreground leading-relaxed">
                {feature.description}
              </p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
};