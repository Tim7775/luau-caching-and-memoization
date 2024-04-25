type LuaTupleFirst<T> = T extends LuaTuple<infer U> ? U[0] : T;

/**
 * Memoize function calls for a single frame
 */
declare function memoizeFrame<T extends (arg: any) => any>(
	callback: T,
): (a: NonNullable<Parameters<T>[0]>) => LuaTupleFirst<ReturnType<T>>;

export = memoizeFrame;
