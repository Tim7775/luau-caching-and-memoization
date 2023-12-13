[![CI](https://github.com/Tim7775/luau-caching-and-memoization/actions/workflows/ci.yaml/badge.svg)](https://github.com/Tim7775/luau-caching-and-memoization/actions/workflows/ci.yaml)

# luau-caching-and-memoization

Most libraries are pure Luau, some require Roblox's task library (a polyfill is available [here](https://github.com/Anaminus/roblox-library/tree/3ca34e755188c168e2dae7d0930feec557c3d2f3/modules/TaskPolyfill))
### Memoization functions
| Module | Dependency | Description |
| -- | -- | -- |
| [memoize](https://github.com/Tim7775/luau-caching-and-memoization/tree/main/src/memoize/init.luau) | [`memoize = "tim7775/memoize@0.1.0"`](https://wally.run/package/tim7775/memoize?version=0.1.0) | Memoize function calls |
| [memoizeAsync](https://github.com/Tim7775/luau-caching-and-memoization/tree/main/src/memoize-async/init.luau) | [`memoizeAsync = "tim7775/memoize-async@0.1.0"`](https://wally.run/package/tim7775/memoize-async?version=0.1.0) | Memoize async function calls |
| [memoizeFrame](https://github.com/Tim7775/luau-caching-and-memoization/tree/main/src/memoize-frame/init.luau) | [`memoizeFrame = "tim7775/memoize-frame@0.1.0"`](https://wally.run/package/tim7775/memoize-frame?version=0.1.0) | Memoize function calls for a single frame |
| [memoizeMulti](https://github.com/Tim7775/luau-caching-and-memoization/tree/main/src/memoize-multi/init.luau) | [`memoizeMulti = "tim7775/memoize-multi@0.1.0"`](https://wally.run/package/tim7775/memoize-multi?version=0.1.0) | Memoize function calls with multiple parameters and return values |
| [memoizeMultiAsync](https://github.com/Tim7775/luau-caching-and-memoization/tree/main/src/memoize-multi-async/init.luau) | [`memoizeMultiAsync = "tim7775/memoize-multi-async@0.1.0"`](https://wally.run/package/tim7775/memoize-multi-async?version=0.1.0) | Memoize async function calls with multiple parameters and return values |
| [memoizeRecentlyUsed](https://github.com/Tim7775/luau-caching-and-memoization/tree/main/src/memoize-recently-used/init.luau) | [`memoizeRecentlyUsed = "tim7775/memoize-recently-used@0.1.0"`](https://wally.run/package/tim7775/memoize-recently-used?version=0.1.0) | Memoization function with a least-recently-used cache eviction policy |

### Caches
| Module | Dependency | Description |
| -- | -- | -- |
| [MultiCache](https://github.com/Tim7775/luau-caching-and-memoization/tree/main/src/multi-cache/init.luau) | [`MultiCache = "tim7775/multi-cache@0.1.1"`](https://wally.run/package/tim7775/multi-cache?version=0.1.1) | Cache that stores any number of values in one entry and accepts keys consisting of multiple values|
