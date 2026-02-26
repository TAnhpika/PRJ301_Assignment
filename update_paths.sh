#!/bin/bash

# Script to update all resource paths in JSP files from old structure to new PRJ301 structure

echo "🔄 Updating resource paths in JSP files..."

# Update CSS paths: /css/ -> /view/assets/css/
find web/view/jsp -name "*.jsp" -type f -exec sed -i '' 's|/css/|/view/assets/css/|g' {} \;
find web/view/jsp -name "*.jsp" -type f -exec sed -i '' 's|contextPath}/css/|contextPath}/view/assets/css/|g' {} \;

# Update JS paths: /js/ -> /view/assets/js/
find web/view/jsp -name "*.jsp" -type f -exec sed -i '' 's|/js/|/view/assets/js/|g' {} \;
find web/view/jsp -name "*.jsp" -type f -exec sed -i '' 's|contextPath}/js/|contextPath}/view/assets/js/|g' {} \;

# Update image paths: /img/ -> /view/assets/img/
find web/view/jsp -name "*.jsp" -type f -exec sed -i '' 's|/img/|/view/assets/img/|g' {} \;
find web/view/jsp -name "*.jsp" -type f -exec sed -i '' 's|contextPath}/img/|contextPath}/view/assets/img/|g' {} \;

# Update font paths: /fonts/ -> /view/assets/font/
find web/view/jsp -name "*.jsp" -type f -exec sed -i '' 's|/fonts/|/view/assets/font/|g' {} \;
find web/view/jsp -name "*.jsp" -type f -exec sed -i '' 's|contextPath}/fonts/|contextPath}/view/assets/font/|g' {} \;

# Update include paths for header/footer
find web/view/jsp -name "*.jsp" -type f -exec sed -i '' 's|/includes/header.jsp|/view/layout/header.jsp|g' {} \;
find web/view/jsp -name "*.jsp" -type f -exec sed -i '' 's|/includes/footer.jsp|/view/layout/footer.jsp|g' {} \;

# Update JSP forward paths in layout files
find web/view/layout -name "*.jsp" -type f -exec sed -i '' 's|/jsp/auth/|/view/jsp/auth/|g' {} \;
find web/view/layout -name "*.jsp" -type f -exec sed -i '' 's|/jsp/patient/|/view/jsp/patient/|g' {} \;
find web/view/layout -name "*.jsp" -type f -exec sed -i '' 's|/jsp/doctor/|/view/jsp/doctor/|g' {} \;
find web/view/layout -name "*.jsp" -type f -exec sed -i '' 's|/jsp/manager/|/view/jsp/admin/|g' {} \;
find web/view/layout -name "*.jsp" -type f -exec sed -i '' 's|/jsp/staff/|/view/jsp/admin/|g' {} \;

echo "✅ Resource paths updated successfully!"
echo "📊 Summary:"
echo "   - CSS paths: /css/ → /view/assets/css/"
echo "   - JS paths: /js/ → /view/assets/js/"
echo "   - Image paths: /img/ → /view/assets/img/"
echo "   - Font paths: /fonts/ → /view/assets/font/"
echo "   - Include paths: /includes/ → /view/layout/"
