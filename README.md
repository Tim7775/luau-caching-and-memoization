[![CI](https://github.com/Tim7775/luau-caching-and-memoization/actions/workflows/ci.yaml/badge.svg)](https://github.com/Tim7775/luau-caching-and-memoization/actions/workflows/ci.yaml)

# luau-caching-and-memoization
Most packages are pure [Luau](https://luau-lang.org/), some require Roblox's task library (a polyfill is available [here](https://github.com/Anaminus/roblox-library/tree/3ca34e755188c168e2dae7d0930feec557c3d2f3/modules/TaskPolyfill)). [Roblox-ts](https://roblox-ts.com/) type declaration files and npm packages are available for [memoizeFrame](https://www.npmjs.com/package/@rbxts/memoize-frame), [memoizeMulti](https://www.npmjs.com/package/@rbxts/memoize-multi), [memoizeMultiAsync](https://www.npmjs.com/package/@rbxts/memoize-multi-async) and [memoizeRecentlyUsed](https://www.npmjs.com/package/@rbxts/memoize-recently-used).

### Memoization Functions ([documentation](https://github.com/Tim7775/luau-caching-and-memoization/tree/main/docs/memoization.md))
| Module | Dependency | Description |
| -- | -- | -- |
| [memoize](https://github.com/Tim7775/luau-caching-and-memoization/tree/main/src/memoize/init.luau) | [`memoize = "tim7775/memoize@0.1.0"`](https://wally.run/package/tim7775/memoize?version=0.1.0) | Memoize function calls |
| [memoizeAsync](https://github.com/Tim7775/luau-caching-and-memoization/tree/main/src/memoize-async/init.luau) | [`memoizeAsync = "tim7775/memoize-async@0.1.0"`](https://wally.run/package/tim7775/memoize-async?version=0.1.0) | Memoize async function calls |
| [memoizeFrame](https://github.com/Tim7775/luau-caching-and-memoization/tree/main/src/memoize-frame/init.luau) | [`memoizeFrame = "tim7775/memoize-frame@0.1.1"`](https://wally.run/package/tim7775/memoize-frame?version=0.1.1) | Memoize function calls for a single frame |
| [memoizeMulti](https://github.com/Tim7775/luau-caching-and-memoization/tree/main/src/memoize-multi/init.luau) | [`memoizeMulti = "tim7775/memoize-multi@0.1.1"`](https://wally.run/package/tim7775/memoize-multi?version=0.1.1) | Memoize function calls with multiple parameters and return values |
| [memoizeMultiAsync](https://github.com/Tim7775/luau-caching-and-memoization/tree/main/src/memoize-multi-async/init.luau) | [`memoizeMultiAsync = "tim7775/memoize-multi-async@0.1.1"`](https://wally.run/package/tim7775/memoize-multi-async?version=0.1.1) | Memoize async function calls with multiple parameters and return values |
| [memoizeRecentlyUsed](https://github.com/Tim7775/luau-caching-and-memoization/tree/main/src/memoize-recently-used/init.luau) | [`memoizeRecentlyUsed = "tim7775/memoize-recently-used@0.1.1"`](https://wally.run/package/tim7775/memoize-recently-used?version=0.1.1) | Memoization function with a least-recently-used cache eviction policy |

### Caches
| Module | Dependency | Description |
| -- | -- | -- |
| [HLRUCache](https://github.com/Tim7775/luau-caching-and-memoization/tree/main/src/hlru-cache/init.luau) | [`HLRUCache = "tim7775/hlru-cache@0.1.0"`](https://wally.run/package/tim7775/hlru-cache?version=0.1.0) | A faster and simpler LRU cache that may be slightly less memory efficient|
| [LRUCache](https://github.com/Tim7775/luau-caching-and-memoization/tree/main/src/lru-cache/init.luau) | [`LRUCache = "tim7775/lru-cache@0.1.0"`](https://wally.run/package/tim7775/lru-cache?version=0.1.0) | Cache with a least-recently-used cache eviction policy|
| [MultiCache](https://github.com/Tim7775/luau-caching-and-memoization/tree/main/src/multi-cache/init.luau) | [`MultiCache = "tim7775/multi-cache@0.1.1"`](https://wally.run/package/tim7775/multi-cache?version=0.1.1) | Cache that stores any number of values in one entry and accepts keys consisting of multiple values|
| [NMRURRCache](https://github.com/Tim7775/luau-caching-and-memoization/tree/main/src/nmru-rr-cache/init.luau) | [`NMRURRCache = "tim7775/nmru-rr-cache@0.1.0"`](https://wally.run/package/tim7775/nmru-rr-cache?version=0.1.0) | Not-most-recently-used random replacement cache|
| [RRCache](https://github.com/Tim7775/luau-caching-and-memoization/tree/main/src/rr-cache/init.luau) | [`RRCache = "tim7775/rr-cache@0.1.0"`](https://wally.run/package/tim7775/rr-cache?version=0.1.0) | Random replacement cache|
