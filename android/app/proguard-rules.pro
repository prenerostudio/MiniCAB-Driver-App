# SLF4J treats StaticLoggerBinder as an optional runtime binding. Some
# dependencies reference it, but the app can run with SLF4J's no-op fallback.
-dontwarn org.slf4j.impl.StaticLoggerBinder
