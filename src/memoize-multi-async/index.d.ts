/**
 * Memoize async function calls with multiple parameters and return values
 */
declare function memoizeMultiAsync<T extends Callback>(callback: T): T;

export = memoizeMultiAsync;
