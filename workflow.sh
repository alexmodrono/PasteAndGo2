if [ -f Tweak.x ]; then
  echo "Compiling theos tweak".
  echo "Performing checks."
  if [ -f Makefile ]; then
    make package
    make do
  fi
else
  echo "Dunno what is happening. Skipping this process..."
fi
