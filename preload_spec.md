### Summary
This document delineates three methods for prefetching *all* of the content requests. While useful, the existing code is only capable of prefetching per *individual* request and hence per *individual* placement. Unfortunately, most developers are also interested in prefetching *all* of the content templates and not just a few select ones. Since the server alone possesses the complete list of placements, we must add some additional API calls. The following sections describe three different methods for prefetching *all* content placements and the relationship between the client and server.

The first method is more server centric while the second is client based. The third is simply a difference in the *sdk-ios*.

### Method 1
#### Client
Two extra methods would be added to the PHContentRequest. Both would be class methods since they do not deal with any particular instance.
+ (void)preloadPlacements:(NSArray*)placements withDelegate:(id <PHPlacementPreloadDelegate>)delegate;
+ (void)preloadAllPlacements withDelegate:(id <PHPlacementPreloadDelegate>)delegate;
+ (PHContentRequest*)preloadedRequestForPlacement:(NSString\*)placement;
	
Both methods would start a request to the server for the content templates with the specified placements. The delegate would be notified when a new PHContentRequest object has been created and it's content has been loaded. Hence, for each content template preloaded the following delegate method would be called:
- (void)contentRequestPreloaded:(PHContentRequest*)preloaded;

We would also create an additional subclass of PHAPIRequest which would request all the prefetched templates described in the "Server" section. The subclass would be called PHPreloadPlacementsRequest.

The last method allows one to easily fetch a preloaded request for a given placement id. 
#### Server
The server API would simply return a large JSON dictionary of the various content templates with the placements as keys. Example:
{"more_games": {..},
"gow": {..}
}

The PHPreloadPlacementsRequest would handle loading this while the static methods would parse and create the various PHContentRequests. Since we would receive all the content templates as a large chunk, we could preload the content for each request without requiring individual NSURLConnections in the __send__ method of each. 



### Method 2
#### Client
The would contain the exact same interface as above but would be slightly different semantically. Instead of returning PHContentRequests which have the content already preloaded, it would return a PHContentRequest for each placement which *hasn't* yet loaded. 

Instead, the static methods would maintain a static queue (like NSOperationQueue) of PHContentRequests and call their __send__ methods individually so that each PHContentRequest uses it's own NSURLConnection to preload its own content. This queue would be sequential to ensure maximum network throughput.

Also, the PHPreloadPlacementsRequest class would not fetch a giant dictionary of the content templates but instead a simple list of all the placements tied to a particular account. The static methods would then create a PHContentRequest for each of these placements ids and call their __send__ methods to begin prefetching.

#### Server
The server would simply return a list of possible placement ids. Instead of generating all content templates and sticking them in a dictionary, it would merely return a listing of placement ids and let the *sdk-ios* do the actual fetching of each content template.


### Method 3
#### Client
This method is identical to the second one except we cache the content templates in a global table. Unlike the second method, instead of returning PHContentRequests via a delegate method we simply store the content templates in a class hash table. 

Then, when the user creates a PHContentRequest and call __send__ after calling the static preload method, the PHContentRequest simply looks for the cached content template in the global hash table. This happens "under the covers" and is hence not apparent to the client. 

The main downside to this approach would be tying all the PHContentRequests to one global hash table. For example, if we had two PHContentRequests with identical placements, they would both pull the same cached copy of the content template. Additionally, separating the preload call into a static method which then influences *all* the instances of PHContentRequests seems a bit messy when evaluating "separation of concerns".

#### Server
The server would be identical to the one described in method two.

### Conclusion
After some careful consideration, I believe the second method provides more flexibility and is less costly. Though potentially more resource intensive than option one, the relatively small number of total placements should alleviate any problems.

The second method places more burden on the client but provides a better fit with the current code, requiring less overall development work as the addition is quite lightweight.

The second method also does not tie each PHContentRequest to a global cache but instead simply provides a "pool" of preloaded requests. Thus, if the developer wishes, he is always free to create another request which does not utilize the cache for the exact same placement id.