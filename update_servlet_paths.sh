#!/bin/bash

# Script to update all forward/redirect paths in Servlet files

echo "🔄 Updating servlet forward/redirect paths..."

# Update auth paths
find src/java/controller -name "*.java" -type f -exec sed -i '' 's|/jsp/auth/|/view/jsp/auth/|g' {} \;

# Update patient paths
find src/java/controller -name "*.java" -type f -exec sed -i '' 's|/jsp/patient/|/view/jsp/patient/|g' {} \;

# Update doctor paths
find src/java/controller -name "*.java" -type f -exec sed -i '' 's|/jsp/doctor/|/view/jsp/doctor/|g' {} \;

# Update manager paths to admin
find src/java/controller -name "*.java" -type f -exec sed -i '' 's|/jsp/manager/|/view/jsp/admin/|g' {} \;

# Update staff paths to admin
find src/java/controller -name "*.java" -type f -exec sed -i '' 's|/jsp/staff/|/view/jsp/admin/|g' {} \;

# Update admin paths
find src/java/controller -name "*.java" -type f -exec sed -i '' 's|/jsp/admin/|/view/jsp/admin/|g' {} \;

# Update public/home paths
find src/java/controller -name "*.java" -type f -exec sed -i '' 's|/public/home.jsp|/view/jsp/home.jsp|g' {} \;

# Update payment paths
find src/java/controller -name "*.java" -type f -exec sed -i '' 's|/payment/|/view/jsp/payment/|g' {} \;

# Update blog paths
find src/java/controller -name "*.java" -type f -exec sed -i '' 's|/jsp/blog/|/view/jsp/blog/|g' {} \;

echo "✅ Servlet paths updated successfully!"
echo "📊 Summary:"
echo "   - Auth: /jsp/auth/ → /view/jsp/auth/"
echo "   - Patient: /jsp/patient/ → /view/jsp/patient/"
echo "   - Doctor: /jsp/doctor/ → /view/jsp/doctor/"
echo "   - Manager: /jsp/manager/ → /view/jsp/admin/"
echo "   - Staff: /jsp/staff/ → /view/jsp/admin/"
echo "   - Home: /public/home.jsp → /view/jsp/home.jsp"
