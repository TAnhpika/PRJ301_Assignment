/**
 * Simple Dashboard JavaScript
 * Minimal functionality for sidebar and dropdowns
 */

// Toggle sidebar dropdown (đóng dropdown khác, mở/đóng dropdown hiện tại)
function toggleDropdown(element) {
    const dropdown = element.closest('.sidebar-dropdown');
    const menu = dropdown ? dropdown.querySelector('.sidebar-dropdown-menu') : null;
    const isOpen = dropdown && dropdown.classList.contains('open');

    document.querySelectorAll('.sidebar-dropdown.open').forEach(function(openDropdown) {
        if (openDropdown !== dropdown) {
            openDropdown.classList.remove('open');
            const openMenu = openDropdown.querySelector('.sidebar-dropdown-menu');
            if (openMenu) openMenu.style.display = 'none';
        }
    });

    if (dropdown && menu) {
        if (isOpen) {
            dropdown.classList.remove('open');
            menu.style.display = 'none';
            element.setAttribute('aria-expanded', 'false');
        } else {
            dropdown.classList.add('open');
            menu.style.display = 'block';
            element.setAttribute('aria-expanded', 'true');
        }
    }
}

// Toggle sidebar on mobile
function toggleSidebar() {
    const sidebar = document.getElementById('sideMenu');
    if (sidebar) {
        sidebar.classList.toggle('show');
    }
}

// Close sidebar when clicking outside on mobile
document.addEventListener('click', function(event) {
    const sidebar = document.getElementById('sideMenu');
    const toggle = document.querySelector('.sidebar-toggle');
    
    if (sidebar && toggle) {
        if (!sidebar.contains(event.target) && !toggle.contains(event.target)) {
            sidebar.classList.remove('show');
        }
    }
});

// Auto-close dropdowns when clicking outside
document.addEventListener('click', function(event) {
    if (!event.target.closest('.sidebar-dropdown')) {
        document.querySelectorAll('.sidebar-dropdown.open').forEach(function(dropdown) {
            dropdown.classList.remove('open');
        });
    }
});

// Highlight active menu item theo URL hiện tại (giữ đúng thẻ li khi click)
(function() {
    const currentPath = window.location.pathname;
    const currentSearch = window.location.search;
    const currentParams = new URLSearchParams(currentSearch);

    function isPerfectMatch(href) {
        if (!href) return false;
        
        // Tạo URL object để parse dễ dàng
        let linkUrl;
        try {
            linkUrl = new URL(href, window.location.origin);
        } catch(e) {
            return false;
        }
        
        const linkPath = linkUrl.pathname;
        const linkSearch = linkUrl.search;
        
        // 1. Kiểm tra pathname (phải khớp hoặc là hậu tố của nhau - xử lý context path)
        const pathMatch = (currentPath === linkPath || currentPath.endsWith(linkPath));
        if (!pathMatch) return false;
        
        // 2. Nếu link có query params, CHỈ match nếu các params đó có mặt và đúng giá trị trong URL hiện tại
        if (linkSearch && linkSearch !== "?") {
            const linkParams = new URLSearchParams(linkSearch);
            let match = true;
            linkParams.forEach((value, key) => {
                if (currentParams.get(key) !== value) match = false;
            });
            return match;
        }
        
        // 3. Nếu link KHÔNG có query params, nhưng URL hiện tại CÓ query params 
        // thì ta chỉ match link này nếu KHÔNG có link nào khác đặc thù hơn (có query) khớp.
        // Tuy nhiên để đơn giản và giải quyết lỗi hiện tại, ta chỉ match nếu URL hiện tại cũng không có query 
        // hoặc query của URL hiện tại không làm thay đổi bản chất trang (tùy logic app).
        // Ở đây, nếu link ko có query mà URL có query, ta vẫn cho là match để active "menu cha" chung.
        return true;
    }

    // Xử lý các items đơn
    document.querySelectorAll('#sideMenu .sidebar-item[href]').forEach(function(item) {
        if (isPerfectMatch(item.getAttribute('href'))) {
            item.classList.add('active');
        } else {
            item.classList.remove('active');
        }
    });

    // Xử lý các items trong dropdown
    document.querySelectorAll('#sideMenu .sidebar-dropdown-item').forEach(function(item) {
        if (isPerfectMatch(item.getAttribute('href'))) {
            item.classList.add('active');
            var dropdown = item.closest('.sidebar-dropdown');
            if (dropdown) {
                dropdown.classList.add('open');
                var menu = dropdown.querySelector('.sidebar-dropdown-menu');
                if (menu) menu.style.display = 'block';
            }
        } else {
            item.classList.remove('active');
        }
    });
})();

// Show toast notification (optional)
function showToast(message, type = 'info') {
    console.log(`[${type.toUpperCase()}] ${message}`);
    // You can add Bootstrap toast here if needed
}

console.log('Dashboard scripts loaded successfully');
