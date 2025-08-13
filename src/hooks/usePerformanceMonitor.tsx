import { useEffect, useRef } from 'react';

interface PerformanceMetrics {
  renderTime: number;
  componentName: string;
  timestamp: number;
}

export const usePerformanceMonitor = (componentName: string) => {
  const renderStartTime = useRef<number>(Date.now());
  const mountTime = useRef<number>();

  useEffect(() => {
    // Track component mount time
    mountTime.current = Date.now();
    
    return () => {
      // Track component unmount and total lifecycle
      const unmountTime = Date.now();
      const totalLifetime = unmountTime - (mountTime.current || 0);
      
      if (process.env.NODE_ENV === 'development') {
        console.log(`🎯 Performance: ${componentName} lifecycle: ${totalLifetime}ms`);
      }
    };
  }, [componentName]);

  const measureRender = () => {
    const renderTime = Date.now() - renderStartTime.current;
    
    if (process.env.NODE_ENV === 'development' && renderTime > 100) {
      console.warn(`⚠️ Slow render detected: ${componentName} took ${renderTime}ms`);
    }
    
    return renderTime;
  };

  const trackInteraction = (actionName: string, duration?: number) => {
    const metrics: PerformanceMetrics = {
      renderTime: duration || measureRender(),
      componentName: `${componentName}.${actionName}`,
      timestamp: Date.now()
    };

    if (process.env.NODE_ENV === 'development') {
      console.log(`📊 Interaction: ${metrics.componentName} - ${metrics.renderTime}ms`);
    }

    // In production, send to analytics service
    if (process.env.NODE_ENV === 'production' && duration && duration > 200) {
      // Could integrate with analytics service here
      console.log('Performance metric logged:', metrics);
    }
  };

  return { measureRender, trackInteraction };
};