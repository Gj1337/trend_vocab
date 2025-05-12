'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"favicon.ico": "d1c1bc75655e7e1feec42268e45feea2",
"splash/img/light-4x.png": "a20b51a0c170ddc01cb1b4be59fcf80d",
"splash/img/dark-4x.png": "a20b51a0c170ddc01cb1b4be59fcf80d",
"splash/img/dark-1x.png": "3c704b56be69679f9927bf3698aeba7b",
"splash/img/light-3x.png": "b919edca3257d4dafa15d81b5a9c69b2",
"splash/img/dark-3x.png": "b919edca3257d4dafa15d81b5a9c69b2",
"splash/img/light-1x.png": "3c704b56be69679f9927bf3698aeba7b",
"splash/img/light-2x.png": "8c2497d6daebb677201077bc60795858",
"splash/img/dark-2x.png": "8c2497d6daebb677201077bc60795858",
"index.html": "9e0a437851b7965bb439b30d32fdfb46",
"/": "9e0a437851b7965bb439b30d32fdfb46",
"manifest.json": "ab4872af260c383cb001d06f6fb276e2",
"main.dart.js": "1907433b13a0d584e125ce55ff2a11da",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"flutter_bootstrap.js": "a40983b8ced94bd793ac0f90a3b452fc",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"icons/Icon-512.png": "c97a36bbba9e83d4ded1f47322c3b111",
"icons/Icon-maskable-192.png": "81cfec323775abe456dd4620c784ee7c",
"icons/Icon-192.png": "81cfec323775abe456dd4620c784ee7c",
"icons/Icon-maskable-512.png": "c97a36bbba9e83d4ded1f47322c3b111",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/fonts/MaterialIcons-Regular.otf": "068a97142cf188aa3fd55f8056ae525e",
"assets/preview.png": "62176fd6a1fbacf594e6d650eae46319",
"assets/AssetManifest.bin": "b5b3b48c97fda2ad50cf8d09f47fafe5",
"assets/AssetManifest.bin.json": "3ee166f1928b115b2a3da8318b97b509",
"assets/NOTICES": "3dfa8354030d1e78e46cd67458163d9a",
"assets/assets/data/expressions.json": "ad9bfa7baf0f0345290621dd48de9666",
"assets/assets/audio/to%2520take%2520off.mp3": "28f9ff3ef15498919d772ad0a0a32899",
"assets/assets/audio/to%2520fluctuate.mp3": "c8b99290cbd6112e8d2c04eda234d3d8",
"assets/assets/audio/the%2520trend%2520was%2520upwards.mp3": "a92d9ef9471b16fdf30346f5a7d1d312",
"assets/assets/audio/to%2520reverse.mp3": "a8b59caba3b1e927b2f6008a8c4a43cd",
"assets/assets/audio/to%2520dip.mp3": "87d98cb4b32a95904cca04f7a169a937",
"assets/assets/audio/to%2520plummet,%2520to%2520plunge.mp3": "ff97104a8e58da3ef1ce90692cec3858",
"assets/assets/audio/to%2520triple.mp3": "0e29ea983b51c2057bf786a402a84c34",
"assets/assets/audio/to%2520surge,%2520to%2520soar,%2520rocket.mp3": "9c03c1d5d9b41acbc478d6673311417d",
"assets/assets/audio/to%2520halve.mp3": "2f6900d39405a7284db9b6956f105261",
"assets/assets/audio/to%2520stabilise,%2520to%2520level%2520off.mp3": "a7a905073c7cf7b87bba49c650ab6003",
"assets/assets/audio/to%2520double.mp3": "b4ccfae141f7c2f747e42b02921e3c2e",
"assets/assets/audio/the%2520trend%2520was%2520downwards.mp3": "63b01ce7684c74b0c14a6e2df7315de5",
"assets/assets/audio/To%2520pick%2520up,%2520to%2520grow,%2520to%2520rise,%2520to%2520elevate.mp3": "809669145958b930215b25dcabfab497",
"assets/assets/audio/To%2520hit,%2520reach%2520a%2520peak,%2520to%2520peak%2520at.mp3": "f254f9707a22accf6039f05f746bdff3",
"assets/assets/audio/To%2520decline,%2520to%2520be%2520on%2520the%2520fall,%2520to%2520drop.mp3": "8dab272622bb3d2c48dad0fe92d5868f",
"assets/assets/audio/To%2520hit%2520the%2520lowest%2520point,%2520to%2520fall%2520to%2520the%2520lowest%2520of.mp3": "3d82f6305a75731b4f40524580f7a2a9",
"assets/assets/audio/To%2520remain%2520stable,to%2520remain%2520constant.mp3": "e73729ebb179c9a104a0a54f43c2df33",
"assets/assets/images/To%2520decline,%2520to%2520be%2520on%2520the%2520fall,%2520to%2520drop.png": "a5fa5e5ede4639069f4d71d1c905c143",
"assets/assets/images/to%2520reverse.png": "419c1dd3d22fa92eeaf10e9af09a758c",
"assets/assets/images/tick.png": "35b05af9649c69c2e598283637d772f9",
"assets/assets/images/to%2520fluctuate.png": "fd3b68da8011b6d6a475d87ba926e1c2",
"assets/assets/images/to%2520triple.png": "6ef348721ebfa6d3c98886c8db7d57d6",
"assets/assets/images/To%2520pick%2520up,%2520to%2520grow,%2520to%2520rise,%2520to%2520elevate.png": "98793b5d7e931a2ae082b36dac8cb907",
"assets/assets/images/to%2520take%2520off.png": "b1809bacbed83a109cd958f92743e104",
"assets/assets/images/To%2520hit,%2520reach%2520a%2520peak,%2520to%2520peak%2520at.png": "9d4b08416e5bc8620d59b2a8b454f8c4",
"assets/assets/images/to%2520halve.png": "acecbf61c96e2783dae6c2feed4206bf",
"assets/assets/images/To%2520remain%2520stable,to%2520remain%2520constant.png": "c5216c397f9b3254824469a5b76849d1",
"assets/assets/images/to%2520plummet,%2520to%2520plunge.png": "e1afe47cdeae7ab8622309b312404a37",
"assets/assets/images/To%2520hit%2520the%2520lowest%2520point,%2520to%2520fall%2520to%2520the%2520lowest%2520of.png": "17755671a0c2d5da832ea445536fe302",
"assets/assets/images/the%2520trend%2520was%2520upwards.png": "8c010b16a66725eac95fb3c5cb99cefc",
"assets/assets/images/cross.png": "0e6100228719ff28fda454b377ab4be8",
"assets/assets/images/the%2520trend%2520was%2520downwards.png": "b6d30d22eb80336fc8dbe77aa6f1a7c0",
"assets/assets/images/to%2520double.png": "e40d8abb48f076f482c8baf16310e4ae",
"assets/assets/images/to%2520dip.png": "7cf7a673fd71472cebd58561c2f32794",
"assets/assets/images/to%2520stabilise,%2520to%2520level%2520off.png": "29ee33430608e6c2c8d20cdbd5855bac",
"assets/assets/images/to%2520surge,%2520to%2520soar,%2520rocket.png": "e88da169a7fa73025592af42fad92901",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.json": "64699c850536244f73acef906d7e2dfb",
"version.json": "d6a19b15ba33e634dd04155657e76766"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
