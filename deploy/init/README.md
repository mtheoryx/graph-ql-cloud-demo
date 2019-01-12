# What is init for

At some point, you have a chicken and the egg problem.

You want to store all state remotely in a backend. (S3)

You want to store other stuff (like workspace state) in a backend
as well (S3)

Someone has to make that first bucket. Somehow. You have two options:

1. Manually click in the console and make the bucket.
2. Create the bucket with TF and commit the state (or lose it)

We chose option 2. That is why we checked in the non-sensitive state.
