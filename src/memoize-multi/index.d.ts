/**
 * Memoize function calls with multiple parameters and return values
 */
declare function memoizeMulti<T extends Callback>(callback: T): T;

export = memoizeMulti;
