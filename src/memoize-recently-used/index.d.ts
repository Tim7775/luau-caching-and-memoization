type LuaTupleFirst<T> = T extends LuaTuple<infer U> ? U[0] : T;

/**
 * Memoization function with a least-recently-used cache eviction policy.
 * Memoizes between pageSize and 2*pageSize results.
 */
declare function memoizeRecentlyUsed<T extends (arg: any) => any>(
	pageSize: number,
	callback: T,
): (a: NonNullable<Parameters<T>[0]>) => LuaTupleFirst<ReturnType<T>>;

export = memoizeRecentlyUsed;
