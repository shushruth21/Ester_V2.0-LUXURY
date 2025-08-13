import { useQuery, UseQueryOptions } from '@tanstack/react-query';
import { useEffect, useRef } from 'react';

interface OptimizedQueryOptions<T> extends Omit<UseQueryOptions<T>, 'queryKey' | 'queryFn'> {
  queryKey: string[];
  queryFn: () => Promise<T>;
  backgroundRefetch?: boolean;
  prefetch?: boolean;
}

export const useOptimizedQuery = <T,>({
  queryKey,
  queryFn,
  backgroundRefetch = true,
  prefetch = false,
  ...options
}: OptimizedQueryOptions<T>) => {
  const queryStartTime = useRef<number>();

  const query = useQuery({
    queryKey,
    queryFn: async () => {
      queryStartTime.current = Date.now();
      try {
        const result = await queryFn();
        const duration = Date.now() - queryStartTime.current;
        
        if (process.env.NODE_ENV === 'development' && duration > 1000) {
          console.warn(`🐌 Slow query: ${queryKey.join('.')} took ${duration}ms`);
        }
        
        return result;
      } catch (error) {
        console.error(`❌ Query failed: ${queryKey.join('.')}`, error);
        throw error;
      }
    },
    staleTime: 5 * 60 * 1000, // 5 minutes
    gcTime: 10 * 60 * 1000, // 10 minutes (formerly cacheTime)
    refetchOnWindowFocus: backgroundRefetch,
    refetchOnMount: 'always',
    retry: (failureCount, error) => {
      // Retry logic: max 3 retries for network errors
      if (failureCount >= 3) return false;
      if (error instanceof Error && error.message.includes('Network')) {
        return true;
      }
      return false;
    },
    retryDelay: (attemptIndex) => Math.min(1000 * 2 ** attemptIndex, 30000),
    ...options,
  });

  // Performance monitoring
  useEffect(() => {
    if (query.isError) {
      console.error(`Query error for ${queryKey.join('.')}:`, query.error);
    }
  }, [query.isError, query.error, queryKey]);

  return query;
};