import React, { useState, useEffect, useRef } from "react";

function InfiniteScroll() {
  // state to store the items being displayed
  const [items, setItems] = useState([]);
  // state to store the current page of items being displayed
  const [page, setPage] = useState(1);
  // state to store the loading status (true while fetching new items)
  const [loading, setLoading] = useState(false);
  // ref to the scroll container element
  const scrollContainerRef = useRef(null);

  useEffect(() => {
    if (loading) return; // if we are already loading, don't do anything

    // function to handle the scroll event on the scroll container
    const handleScroll = () => {
      // get the scroll container element, its scroll height, and its current scroll position
      const { scrollHeight, clientHeight, scrollTop } =
        scrollContainerRef.current;
      // calculate whether the user has scrolled to the bottom of the list (80% from the bottom)
      const reachedBottom = scrollHeight - clientHeight * 1.2 <= scrollTop + 1;

      if (reachedBottom) {
        // if the bottom is reached, set the loading state to true and fetch the next page of items
        setLoading(true);
        // fetch the next page of items here
        // for example, using the Fetch API:
        fetch(`https://my-api/items?page=${page}`)
          .then((response) => response.json())
          .then((data) => {
            // add the new items to the existing items and update the page and loading state
            setItems(items.concat(data));
            setPage(page + 1);
            setLoading(false);
          });
      }
    };

    // get the scroll container element
    const container = scrollContainerRef.current;
    // add the scroll event listener to the container
    container.addEventListener("scroll", handleScroll);

    // the returned function will be called when the component is unmounted,
    // so we can remove the event listener to avoid memory leaks
    return () => {
      container.removeEventListener("scroll", handleScroll);
    };
  }, [page, loading]); // re-run the effect when page or loading state changes

  return (
    <div ref={scrollContainerRef} className="infinite-scroll">
      {items.map((item) => (
        <div key={item.id}>{item.name}</div>
      ))}
      {loading && <div>Loading...</div>}
    </div>
  );
}
