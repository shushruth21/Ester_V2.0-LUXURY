import { Hero } from "@/components/Hero";
import { CategoryGrid } from "@/components/CategoryGrid";
import { Features } from "@/components/Features";

export const Home = () => {
  return (
    <div className="min-h-screen">
      <Hero />
      <CategoryGrid />
      <Features />
    </div>
  );
};