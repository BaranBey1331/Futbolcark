# Keep Kotlinx serialization models
-keepclassmembers class ** {
    @kotlinx.serialization.Serializable *;
}
-keep @kotlinx.serialization.Serializable class * { *; }

# Compose: keep annotations (usually safe)
-keepattributes *Annotation*
