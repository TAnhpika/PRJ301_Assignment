#!/bin/bash

# Script to clean, rebuild and redeploy TestFull project
# This fixes font encoding issues by clearing all caches

echo "🧹 Cleaning project..."

# Step 1: Clean build directory
cd /Users/tranhongphuoc/NetBeansProjects/PM/TestFull
rm -rf build/web 2>/dev/null
echo "✅ Cleaned build/web directory"

# Step 2: Clean Tomcat work directory (compiled JSPs)
rm -rf ~/Library/Tomcat/work/Catalina/localhost/TestFull 2>/dev/null
echo "✅ Cleaned Tomcat work directory"

# Step 3: Find and kill Tomcat processes on port 8081
PIDS=$(lsof -ti:8081 2>/dev/null)
if [ ! -z "$PIDS" ]; then
    echo "🛑 Stopping Tomcat (PIDs: $PIDS)..."
    kill -9 $PIDS 2>/dev/null
    sleep 2
    echo "✅ Tomcat stopped"
else
    echo "ℹ️  Tomcat not running"
fi

echo ""
echo "✅ Cleanup complete!"
echo ""
echo "📝 Next steps:"
echo "1. In NetBeans, right-click project TestFull → Build"
echo "2. Start Tomcat server"
echo "3. Open browser and test: http://localhost:8081/TestFull/LoginServlet"
echo ""
echo "Font encoding should now display correctly! ✨"
