# HMS Push Kit ProGuard Rules
# Keep HMS Push Kit classes
-keep class com.huawei.hms.**{*;}
-keep class com.huawei.agconnect.**{*;}
-dontwarn com.huawei.hms.**
-dontwarn com.huawei.agconnect.**

# Keep HMS Push Service
-keep class com.example.fv2.HmsPushService { *; }

# Keep model classes for HMS Push
-keepclassmembers class * {
    @com.huawei.hms.push.* <fields>;
}

# Keep HMS interfaces
-keep interface com.huawei.hms.** { *; }

