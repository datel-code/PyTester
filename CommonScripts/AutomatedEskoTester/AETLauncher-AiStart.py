import sys
import time
import win32com.client


def main():
    # Parameters
    timer = 5  # seconds
    counter = 10
    no_of_args = 1

    # Check the number of arguments
    if len(sys.argv) != no_of_args + 1:
        print(f"Python Error: Wrong number of parameters. {no_of_args} expected, {len(sys.argv) - 1} received.")
        sys.exit(99)

    # Set processing parameters
    ai_name = sys.argv[1]
    # ai_name = "Illustrator.Application.29"

    # Launch Illustrator
    print("Python: Launching Illustrator...")
    app_ref = win32com.client.Dispatch(ai_name)
    print("Python: AI Launched, waiting to start the script safely.")

    # Wait for a safe start
    for waiter in range(counter, -1, -1):
        time.sleep(timer) 
        print(f"{waiter} ... ", end='', flush=True)

    print("\n")

if __name__ == "__main__":
    main()