/**
 * Dashboard Common JavaScript
 * Unified functionality for all dashboard roles
 */

// ========================================
// Sidebar Toggle
// ========================================
function toggleSidebar() {
    const sidebar = document.querySelector('.dashboard-sidebar');
    const overlay = document.querySelector('.sidebar-overlay');
    
    if (sidebar) {
        sidebar.classList.toggle('show');
    }
    
    if (overlay) {
        overlay.classList.toggle('show');
    }
}

// ========================================
// Sidebar Dropdown
// ========================================
function toggleDropdown(element) {
    const dropdownParent = element.closest('.sidebar-dropdown');
    const allDropdowns = document.querySelectorAll('.sidebar-dropdown');
    
    // Close all other dropdowns
    allDropdowns.forEach(dropdown => {
        if (dropdown !== dropdownParent) {
            dropdown.classList.remove('open');
        }
    });
    
    // Toggle current dropdown
    if (dropdownParent) {
        dropdownParent.classList.toggle('open');
    }
}

// ========================================
// Active Menu Highlighting
// ========================================
function highlightActiveMenu() {
    const currentPath = window.location.pathname;
    const currentPage = currentPath.split('/').pop();
    
    // Highlight main menu items
    document.querySelectorAll('.sidebar-item').forEach(item => {
        const link = item.getAttribute('href') || item.querySelector('a')?.getAttribute('href');
        if (link) {
            const linkPage = link.split('/').pop();
            if (linkPage === currentPage || currentPath.includes(link)) {
                item.classList.add('active');
            }
        }
    });
    
    // Highlight dropdown items and open parent
    document.querySelectorAll('.sidebar-dropdown-item').forEach(item => {
        const link = item.getAttribute('href');
        if (link) {
            const linkPage = link.split('/').pop();
            if (linkPage === currentPage || currentPath.includes(link)) {
                item.classList.add('active');
                const dropdownParent = item.closest('.sidebar-dropdown');
                if (dropdownParent) {
                    dropdownParent.classList.add('open');
                }
            }
        }
    });
}

// ========================================
// Close Sidebar on Outside Click (Mobile)
// ========================================
function handleOutsideClick(event) {
    const sidebar = document.querySelector('.dashboard-sidebar');
    const toggleBtn = document.querySelector('.sidebar-toggle');
    
    if (sidebar && sidebar.classList.contains('show')) {
        if (!sidebar.contains(event.target) && !toggleBtn?.contains(event.target)) {
            sidebar.classList.remove('show');
            const overlay = document.querySelector('.sidebar-overlay');
            if (overlay) {
                overlay.classList.remove('show');
            }
        }
    }
}

// ========================================
// Notification Badge Update
// ========================================
function updateNotificationBadge(count) {
    const badge = document.querySelector('.notification-badge');
    if (badge) {
        if (count > 0) {
            badge.textContent = count > 99 ? '99+' : count;
            badge.style.display = 'flex';
        } else {
            badge.style.display = 'none';
        }
    }
}

// ========================================
// Toast Notification
// ========================================
function showToast(message, type = 'info', duration = 3000) {
    // Create toast container if not exists
    let toastContainer = document.querySelector('.toast-container');
    if (!toastContainer) {
        toastContainer = document.createElement('div');
        toastContainer.className = 'toast-container';
        toastContainer.style.cssText = `
            position: fixed;
            top: 80px;
            right: 20px;
            z-index: 9999;
            display: flex;
            flex-direction: column;
            gap: 10px;
        `;
        document.body.appendChild(toastContainer);
    }
    
    // Create toast element
    const toast = document.createElement('div');
    toast.className = `toast-notification toast-${type}`;
    toast.style.cssText = `
        padding: 14px 20px;
        border-radius: 8px;
        background-color: #fff;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        display: flex;
        align-items: center;
        gap: 12px;
        min-width: 280px;
        animation: slideIn 0.3s ease;
    `;
    
    // Icon based on type
    const icons = {
        success: '<i class="fas fa-check-circle" style="color: #28A745;"></i>',
        error: '<i class="fas fa-times-circle" style="color: #DC3545;"></i>',
        warning: '<i class="fas fa-exclamation-triangle" style="color: #FFC107;"></i>',
        info: '<i class="fas fa-info-circle" style="color: #4E80EE;"></i>'
    };
    
    toast.innerHTML = `
        ${icons[type] || icons.info}
        <span style="flex: 1; font-size: 14px; color: #333;">${message}</span>
        <button onclick="this.parentElement.remove()" style="
            background: none;
            border: none;
            font-size: 18px;
            cursor: pointer;
            color: #999;
            padding: 0;
        ">&times;</button>
    `;
    
    toastContainer.appendChild(toast);
    
    // Auto remove
    setTimeout(() => {
        toast.style.animation = 'slideOut 0.3s ease';
        setTimeout(() => toast.remove(), 300);
    }, duration);
}

// ========================================
// Confirm Dialog
// ========================================
function confirmAction(message, onConfirm, onCancel) {
    const overlay = document.createElement('div');
    overlay.style.cssText = `
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(0, 0, 0, 0.5);
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 9999;
    `;
    
    const dialog = document.createElement('div');
    dialog.style.cssText = `
        background: #fff;
        border-radius: 12px;
        padding: 24px;
        max-width: 400px;
        width: 90%;
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
    `;
    
    dialog.innerHTML = `
        <h3 style="margin: 0 0 16px 0; font-size: 18px; color: #333;">Xác nhận</h3>
        <p style="margin: 0 0 24px 0; color: #666; font-size: 14px;">${message}</p>
        <div style="display: flex; gap: 12px; justify-content: flex-end;">
            <button class="btn-cancel" style="
                padding: 10px 20px;
                border: 1px solid #ddd;
                background: #fff;
                border-radius: 8px;
                cursor: pointer;
                font-size: 14px;
            ">Hủy</button>
            <button class="btn-confirm" style="
                padding: 10px 20px;
                border: none;
                background: #4E80EE;
                color: #fff;
                border-radius: 8px;
                cursor: pointer;
                font-size: 14px;
            ">Xác nhận</button>
        </div>
    `;
    
    overlay.appendChild(dialog);
    document.body.appendChild(overlay);
    
    dialog.querySelector('.btn-cancel').onclick = () => {
        overlay.remove();
        if (onCancel) onCancel();
    };
    
    dialog.querySelector('.btn-confirm').onclick = () => {
        overlay.remove();
        if (onConfirm) onConfirm();
    };
    
    overlay.onclick = (e) => {
        if (e.target === overlay) {
            overlay.remove();
            if (onCancel) onCancel();
        }
    };
}

// ========================================
// Loading Spinner
// ========================================
function showLoading(show = true) {
    let loader = document.querySelector('.loading-overlay');
    
    if (show) {
        if (!loader) {
            loader = document.createElement('div');
            loader.className = 'loading-overlay';
            loader.style.cssText = `
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: rgba(255, 255, 255, 0.8);
                display: flex;
                align-items: center;
                justify-content: center;
                z-index: 9999;
            `;
            loader.innerHTML = `
                <div style="text-align: center;">
                    <div class="spinner" style="
                        width: 40px;
                        height: 40px;
                        border: 3px solid #f3f3f3;
                        border-top: 3px solid #4E80EE;
                        border-radius: 50%;
                        animation: spin 1s linear infinite;
                        margin: 0 auto 16px;
                    "></div>
                    <p style="color: #666; font-size: 14px;">Đang tải...</p>
                </div>
            `;
            document.body.appendChild(loader);
        }
    } else {
        if (loader) {
            loader.remove();
        }
    }
}

// ========================================
// Add CSS Animations
// ========================================
const styleSheet = document.createElement('style');
styleSheet.textContent = `
    @keyframes slideIn {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
    
    @keyframes slideOut {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(100%);
            opacity: 0;
        }
    }
    
    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }
    
    .sidebar-overlay {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(0, 0, 0, 0.5);
        z-index: 999;
        display: none;
    }
    
    .sidebar-overlay.show {
        display: block;
    }
`;
document.head.appendChild(styleSheet);

// ========================================
// Initialize
// ========================================
document.addEventListener('DOMContentLoaded', function() {
    highlightActiveMenu();
    
    // Add overlay for mobile
    if (!document.querySelector('.sidebar-overlay')) {
        const overlay = document.createElement('div');
        overlay.className = 'sidebar-overlay';
        overlay.onclick = toggleSidebar;
        document.body.appendChild(overlay);
    }
    
    // Handle outside click
    document.addEventListener('click', handleOutsideClick);
});

// Export functions for global use
window.toggleSidebar = toggleSidebar;
window.toggleDropdown = toggleDropdown;
window.showToast = showToast;
window.confirmAction = confirmAction;
window.showLoading = showLoading;
window.updateNotificationBadge = updateNotificationBadge;
