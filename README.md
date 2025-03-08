Test OpenCV build with various BLAS/LAPACK libraries.

Assuming following folder layout:
```
opencv/
opencv_blas-check/ (this repository)
├─ workspace/
├─ scripts/
│  ├─ check.sh
run.sh
```

Instruction (run in current directory):
- `./run.sh` - build and run check script in Docker containers
