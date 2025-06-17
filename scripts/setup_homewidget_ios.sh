#!/bin/bash
set -e

# Configurable variables
group_id="group.com.mycompany.homewidget"
extension_name="HomeWidget"
extension_dir="ios/$extension_name"
project_file="ios/Runner.xcodeproj/project.pbxproj"

# 1. Create the HomeWidget extension directory if it doesn't exist
mkdir -p "$extension_dir"

# 2. Create HomeWidget.swift if not present
swift_file="$extension_dir/$extension_name.swift"
if [ ! -f "$swift_file" ]; then
cat > "$swift_file" <<EOF
import WidgetKit
import SwiftUI

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct $extension_name: Widget {
    let kind: String = "$extension_name"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Text(entry.date, style: .time)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        completion(SimpleEntry(date: Date()))
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let entries = [SimpleEntry(date: Date())]
        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

@main
struct $extension_nameBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        $extension_name()
    }
}
EOF
fi

# 3. Create Info.plist for the extension
plist_file="$extension_dir/Info.plist"
if [ ! -f "$plist_file" ]; then
cat > "$plist_file" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>
        \\$(DEVELOPMENT_LANGUAGE)
    </string>
    <key>CFBundleDisplayName</key>
    <string>$extension_name</string>
    <key>CFBundleIdentifier</key>
    <string>com.mycompany.homewidget.widget</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>$extension_name</string>
    <key>CFBundlePackageType</key>
    <string>XPC!</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>NSExtension</key>
    <dict>
        <key>NSExtensionPointIdentifier</key>
        <string>com.apple.widgetkit-extension</string>
        <key>NSExtensionPrincipalClass</key>
        <string>$(PRODUCT_MODULE_NAME).$extension_nameBundle</string>
    </dict>
</dict>
</plist>
EOF
fi

# 4. Create HomeWidget.entitlements
entitlements_file="$extension_dir/$extension_name.entitlements"
if [ ! -f "$entitlements_file" ]; then
cat > "$entitlements_file" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.application-groups</key>
    <array>
        <string>$group_id</string>
    </array>
</dict>
</plist>
EOF
fi

# 5. Add the HomeWidget target to the Xcode project if not present
if ! grep -q "$extension_name" "$project_file"; then
  echo "Adding $extension_name target to Xcode project (manual step may be required for full integration)."
  # NOTE: Full Xcode project automation is complex and may require a tool like 'xcodeproj' or 'tuist'.
  # For now, this script creates all files and warns the user to add the target manually if not present.
fi

# 6. Optionally create a config file if needed
config_file="homewidget-config.env"
if [ ! -f "$config_file" ]; then
cat > "$config_file" <<EOF
# HomeWidget config example
GROUP_ID=$group_id
EOF
fi

echo "HomeWidget extension files are set up. Please ensure the Xcode target is added if not already present." 
