/**
 *
 * @file ctp.pike
 *
 * @brief 
 *
 * @authors Roger Truchero Visa
 *
 */


// Global variables
int to_chase;
int result_a, result_b;
array(int) a, b;

 // Main program
 int main(int argc, array(string) argv)
 {
 	float seconds_to_execute = gauge
 	{
 		to_chase = 231;
		a = Array.sort(({ 1, 23, 45, 66, 84, 113, 145, 178, 205, 210, 221, 250, 264, 300 }));
	 	b = Array.sort(({ 5, 31, 40, 52, 73, 103, 126, 162, 195, 214, 225, 241, 256, 267 }));
	 	
	 	if(to_chase < a[0] || to_chase < b[0] || to_chase > a[-1] || to_chase > b[-1])
	 	{
	 		write("Invalid to_chase number.\n");
	 		return 0;
	 	}
	};
	write("Seconds to sort: " + seconds_to_execute + "\n");


	seconds_to_execute = gauge
	{
		thread_version();	 
	};
	write("Seconds to execute thread version: " + seconds_to_execute + "\n");


	seconds_to_execute = gauge
	{
		thread_version();	 
	};
	write("Seconds to execute sequential version: " + seconds_to_execute + "\n");

	return 0;
 }

// Function to resolve the problem with threads
void thread_version()
{	 	
	// Create two threads for each array
 	array(array(function(:void)|array)) fun_args = 
 	({
 		({ find_closest, ({ a, sizeof(a), to_chase }) }),
 		({ find_closest, ({ b, sizeof(b), to_chase }) })
 	});

	object result = Thread.Farm()->run_multiple(fun_args);

 	array(int) res = result();

	write("Chase pair: [" + res[0] + ", " + res[1] + "]\n");
}

// Function to resolve the problem sequentially
void sequential_version()
{
	result_a = find_closest(a, sizeof(a), to_chase);
 	result_b = find_closest(b, sizeof(b), to_chase);
	write("Chase pair: [" + result_a + ", " + result_b + "]\n");
}

// Returns element closest to to_chase in arr
int find_closest(array(int) arr, int n, int to_chase) 
{ 
    // Doing binary search 
    int i = 0, j = n, mid = 0; 

    while(i < j) 
    { 
        mid = (i + j) / 2; 
  
        if (arr[mid] == to_chase) return arr[mid]; 
  
        // If to_chase is less than array element, then search in left 
        if (to_chase < arr[mid]) 
        { 
            // If to_chase is greater than previous to mid, return closest of two 
            if (mid > 0 && to_chase > arr[mid - 1]) return get_closest(arr[mid - 1], arr[mid], to_chase); 
  
            // Repeat for left half 
            j = mid; 
        }
        else  // If to_chase is greater than mid 
        { 
            if (mid < n - 1 && to_chase < arr[mid + 1]) return get_closest(arr[mid], arr[mid + 1], to_chase); 
       
            i = mid + 1;  
        } 
    } 

    // Only single element left after search 
    return arr[mid]; 
} 
  
// Function to know which number is the closest
int get_closest(int val1, int val2, int to_chase) 
{ 
    if (to_chase - val1 >= val2 - to_chase) 
        return val2; 
    else
        return val1; 
}