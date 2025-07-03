// Error suppression for ResizeObserver warnings
// This script suppresses the common ResizeObserver warning that appears in Chrome extensions

window.addEventListener('error', function (e) {
  if (e.message && e.message.includes('ResizeObserver loop completed with undelivered notifications')) {
    e.stopImmediatePropagation();
    return false;
  }
});

// Also suppress console warnings for ResizeObserver
const originalConsoleWarn = console.warn;
console.warn = function(...args) {
  const message = args.join(' ');
  if (message.includes('ResizeObserver loop completed with undelivered notifications')) {
    return; // Suppress this specific warning
  }
  originalConsoleWarn.apply(console, args);
};
