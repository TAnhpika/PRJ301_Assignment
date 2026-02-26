<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="dao.MedicineDAO" %>
    <%@page import="model.Medicine" %>
<%@page import="model.User" %>
        <%@page import="java.util.List" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"STAFF".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }
    List<Medicine> medicines = (List<Medicine>) request.getAttribute("medicines");
                            if (medicines == null) {
                            MedicineDAO dao = new MedicineDAO();
                            medicines = dao.getAllMedicine();
                            }
                            %>

                            <!DOCTYPE html>
                            <html lang="vi">
                            <head>
    <%@ include file="/includes/dashboard_head.jsp" %>
    <title>Quầy Thuốc - Staff</title>
    <style>
        .medicine-card {
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            padding: 15px;
            cursor: pointer;
            transition: all 0.3s;
            background: white;
        }
        .medicine-card:hover {
            border-color: #4361ee;
            box-shadow: 0 4px 12px rgba(67, 97, 238, 0.15);
        }
        .medicine-card.selected {
            border-color: #4361ee;
            background: #f0f9ff;
        }
        .cart-item {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 12px;
            margin-bottom: 10px;
        }
        .payment-btn {
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            padding: 12px;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s;
        }
        .payment-btn.active {
            border-color: #4361ee;
            background: #f0f9ff;
            color: #4361ee;
        }
    </style>
                            </head>
<body>
    <div class="dashboard-wrapper">
        <%@ include file="/jsp/staff/staff_menu.jsp" %>
        
        <main class="dashboard-main">
            <%@ include file="/jsp/staff/staff_header.jsp" %>
            
            <div class="dashboard-content">
                <!-- Page Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="mb-1"><i class="fas fa-pills me-2"></i>Quầy Thuốc</h4>
                        <p class="text-muted mb-0">Bán thuốc và tạo hóa đơn cho khách hàng</p>
                                            </div>
                    <div class="text-end">
                        <small class="text-muted">Nhân viên: <strong><%= user.getUsername() %></strong></small><br>
                        <small class="text-muted"><%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(new java.util.Date()) %></small>
                                            </div>
                                        </div>
                
                <div class="row">
                    <!-- Medicine List -->
                    <div class="col-lg-8 mb-4">
                        <div class="dashboard-card">
                            <div class="mb-3">
                                <div class="input-group">
                                    <span class="input-group-text bg-white"><i class="fas fa-search text-muted"></i></span>
                                    <input type="text" class="form-control" id="searchInput" placeholder="Tìm kiếm thuốc..." onkeyup="searchMedicine()">
                                </div>
                                            </div>

                            <div class="row g-3" id="medicineGrid" style="max-height: 500px; overflow-y: auto;">
                                <% if (medicines != null && medicines.size() > 0) {
                                                    for (Medicine medicine : medicines) {
                                        String unitDisplay = medicine.getUnit() != null ? medicine.getUnit() : "Viên";
                                                    %>
                                <div class="col-md-6 col-lg-4 medicine-item">
                                    <div class="medicine-card" 
                                                        data-id="<%= medicine.getMedicineId() %>"
                                                        data-name="<%= medicine.getName() %>"
                                                        data-unit="<%= unitDisplay %>"
                                         data-stock="<%= medicine.getQuantityInStock() %>"
                                         onclick="addToCart(this)">
                                        <h6 class="mb-2"><%= medicine.getName() %></h6>
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <small class="text-muted"><%= unitDisplay %></small>
                                            <span class="badge bg-<%= medicine.getQuantityInStock() > 10 ? "success" : medicine.getQuantityInStock() > 0 ? "warning" : "danger" %>">
                                                                Còn: <%= medicine.getQuantityInStock() %>
                                                            </span>
                                                        </div>
                                        <div class="text-success fw-bold">10,000 VNĐ</div>
                                        <% if (medicine.getDescription() != null && !medicine.getDescription().trim().isEmpty()) { %>
                                        <small class="text-muted d-block mt-2" style="font-size: 11px;"><%= medicine.getDescription() %></small>
                                                            <% } %>
                                    </div>
                                                    </div>
                                                    <% } } else { %>
                                <div class="col-12 text-center py-5">
                                    <i class="fas fa-pills text-muted" style="font-size: 48px;"></i>
                                    <p class="text-muted mt-3">Không có thuốc nào trong kho</p>
                                                        </div>
                                                        <% } %>
                                            </div>
                                        </div>
                                            </div>

                    <!-- Cart -->
                    <div class="col-lg-4 mb-4">
                        <div class="dashboard-card">
                            <h6 class="mb-3">
                                <i class="fas fa-shopping-cart me-2"></i>Giỏ hàng
                                <span class="badge bg-danger ms-2" id="cartCount">0</span>
                            </h6>
                            
                            <div id="cartItems" style="max-height: 200px; overflow-y: auto;">
                                <div class="text-center py-4 text-muted">
                                    <i class="fas fa-cart-plus" style="font-size: 32px;"></i>
                                    <p class="mt-2 mb-0">Chọn thuốc để thêm vào giỏ</p>
                                                </div>
                                            </div>

                            <hr>
                            
                            <div class="stat-card success mb-3" style="padding: 15px;">
                                <div class="text-center">
                                    <div class="stat-card-value" id="totalAmount" style="font-size: 24px;">0 VNĐ</div>
                                    <small>Tổng thanh toán</small>
                                                </div>
                                            </div>

                            <div class="mb-3">
                                <label class="form-label">Tên khách hàng (tùy chọn)</label>
                                <input type="text" class="form-control" id="customerName" placeholder="Để trống = 'Khách mua thuốc'">
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Phương thức thanh toán</label>
                                <div class="row g-2">
                                    <div class="col-6">
                                        <div class="payment-btn active" data-method="CASH" onclick="selectPayment(this)">
                                            <i class="fas fa-money-bill"></i><br>
                                            <small>Tiền mặt</small>
                                        </div>
                                    </div>
                                    <div class="col-6">
                                        <div class="payment-btn" data-method="BANK_TRANSFER" onclick="selectPayment(this)">
                                            <i class="fas fa-university"></i><br>
                                            <small>Chuyển khoản</small>
                                    </div>
                                </div>
                                    <div class="col-6">
                                        <div class="payment-btn" data-method="CARD" onclick="selectPayment(this)">
                                            <i class="fas fa-credit-card"></i><br>
                                            <small>Thẻ</small>
                                        </div>
                                    </div>
                                    <div class="col-6">
                                        <div class="payment-btn" data-method="MOMO" onclick="selectPayment(this)">
                                            <i class="fas fa-mobile-alt"></i><br>
                                            <small>MoMo</small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <button id="checkoutBtn" class="btn btn-success w-100" onclick="createBill()" disabled>
                                <i class="fas fa-receipt me-2"></i>Bán thuốc & In hóa đơn
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <!-- Bill Modal -->
    <div class="modal fade" id="billModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-receipt me-2"></i>Hóa đơn bán thuốc</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <pre id="billContent" style="background: #f8f9fa; padding: 15px; border-radius: 8px; font-size: 12px;"></pre>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-primary" onclick="printBill()"><i class="fas fa-print me-2"></i>In hóa đơn</button>
                    <button class="btn btn-success" onclick="newSale()"><i class="fas fa-plus me-2"></i>Bán hàng mới</button>
                </div>
            </div>
        </div>
    </div>
    
    <%@ include file="/includes/dashboard_scripts.jsp" %>

                                <script>
                                    let cart = {};
                                    let selectedPaymentMethod = 'CASH';
                                    const staffName = '<%= user.getUsername() %>';

        function searchMedicine() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            document.querySelectorAll('.medicine-item').forEach(item => {
                const name = item.querySelector('.medicine-card').dataset.name.toLowerCase();
                item.style.display = name.includes(searchTerm) ? '' : 'none';
            });
        }

                                    function addToCart(card) {
                                        const id = card.dataset.id;
                                        const name = card.dataset.name;
                                        const unit = card.dataset.unit;
                                        const stock = parseInt(card.dataset.stock);

            if (stock <= 0) { alert('Thuốc này đã hết hàng!'); return; }

                                        const currentQuantity = cart[id] ? cart[id].quantity : 0;
                                        const maxQuantity = stock - currentQuantity;

            if (maxQuantity <= 0) { alert('Đã thêm hết số lượng có sẵn!'); return; }

            const quantity = prompt('Nhập số lượng muốn thêm (1-' + maxQuantity + '):', '1');
            if (quantity === null) return;

                                        const qty = parseInt(quantity);
                                        if (isNaN(qty) || qty < 1 || qty > maxQuantity) {
                alert('Số lượng không hợp lệ!');
                                            return;
                                        }

                                        if (cart[id]) {
                                            cart[id].quantity += qty;
                                        } else {
                                            cart[id] = { name, unit, stock, quantity: qty, price: 10000 };
            }

            card.classList.add('selected');
                                        updateCart();
                                    }

                                    function removeFromCart(id) {
                                        delete cart[id];
            document.querySelector('[data-id="' + id + '"]').classList.remove('selected');
                                        updateCart();
                                    }

        function updateQuantity(id, qty) {
            if (qty <= 0) { removeFromCart(id); return; }
            if (qty > cart[id].stock) { alert('Không đủ số lượng trong kho!'); return; }
            cart[id].quantity = qty;
                                        updateCart();
                                    }

                                    function updateCart() {
                                        const cartItems = document.getElementById('cartItems');
                                        const cartCount = document.getElementById('cartCount');
                                        const totalAmount = document.getElementById('totalAmount');
                                        const checkoutBtn = document.getElementById('checkoutBtn');

                                        const itemCount = Object.keys(cart).length;
                                        cartCount.textContent = itemCount;

                                        if (itemCount === 0) {
                cartItems.innerHTML = '<div class="text-center py-4 text-muted"><i class="fas fa-cart-plus" style="font-size: 32px;"></i><p class="mt-2 mb-0">Chọn thuốc để thêm vào giỏ</p></div>';
                totalAmount.textContent = '0 VNĐ';
                                            checkoutBtn.disabled = true;
                                            return;
                                        }

                                        let total = 0;
                                        let html = '';

                                        Object.entries(cart).forEach(([id, item]) => {
                                            const itemTotal = item.quantity * item.price;
                                            total += itemTotal;

                html += '<div class="cart-item">' +
                    '<div class="d-flex justify-content-between mb-1">' +
                        '<strong>' + item.name + '</strong>' +
                        '<button class="btn btn-sm btn-link text-danger p-0" onclick="removeFromCart(\'' + id + '\')"><i class="fas fa-times"></i></button>' +
                    '</div>' +
                    '<small class="text-muted">' + item.price.toLocaleString('vi-VN') + ' VNĐ/' + item.unit + '</small>' +
                    '<div class="d-flex align-items-center mt-2">' +
                        '<button class="btn btn-sm btn-outline-secondary" onclick="updateQuantity(\'' + id + '\',' + (item.quantity-1) + ')">-</button>' +
                        '<span class="mx-2">' + item.quantity + '</span>' +
                        '<button class="btn btn-sm btn-outline-secondary" onclick="updateQuantity(\'' + id + '\',' + (item.quantity+1) + ')">+</button>' +
                        '<span class="ms-auto text-success fw-bold">' + itemTotal.toLocaleString('vi-VN') + ' VNĐ</span>' +
                    '</div>' +
                '</div>';
                                        });

                                        cartItems.innerHTML = html;
            totalAmount.textContent = total.toLocaleString('vi-VN') + ' VNĐ';
                                        checkoutBtn.disabled = false;
        }

        function selectPayment(el) {
            document.querySelectorAll('.payment-btn').forEach(btn => btn.classList.remove('active'));
            el.classList.add('active');
            selectedPaymentMethod = el.dataset.method;
                                    }

                                    function createBill() {
            if (Object.keys(cart).length === 0) { alert('Vui lòng chọn ít nhất một loại thuốc!'); return; }

            const customerName = document.getElementById('customerName').value.trim() || 'Khách mua thuốc';
                                            const checkoutBtn = document.getElementById('checkoutBtn');
            checkoutBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...';
                                            checkoutBtn.disabled = true;

                                            const formData = new FormData();
            formData.append('customer_name', customerName);
            formData.append('payment_method', selectedPaymentMethod);

                                            Object.entries(cart).forEach(([id, item]) => {
                                                formData.append('medicine_id', id);
                                                formData.append('quantity', item.quantity);
                                            });

            fetch('${pageContext.request.contextPath}/StaffSellMedicineServlet', {
                                                method: 'POST',
                body: formData
                                            })
            .then(r => r.json())
                                                .then(data => {
                checkoutBtn.innerHTML = '<i class="fas fa-receipt me-2"></i>Bán thuốc & In hóa đơn';
                                                    checkoutBtn.disabled = false;

                                                    if (data.success) {
                                                        showBillModal(data);
                                                    } else {
                                                        alert('Lỗi: ' + data.message);
                                                    }
                                                })
            .catch(err => {
                alert('Lỗi kết nối: ' + err.message);
                checkoutBtn.innerHTML = '<i class="fas fa-receipt me-2"></i>Bán thuốc & In hóa đơn';
                                                    checkoutBtn.disabled = false;
                                                });
                                    }

        function showBillModal(data) {
                                        let details = '';
                                        Object.entries(cart).forEach(([id, item]) => {
                                            const itemTotal = item.quantity * item.price;
                details += '• ' + item.name + '\n  ' + item.quantity + ' ' + item.unit + ' × ' + item.price.toLocaleString('vi-VN') + ' = ' + itemTotal.toLocaleString('vi-VN') + ' VNĐ\n\n';
            });

            const billText = '═══════════════════════════════════════\n' +
                '       NHA KHOA HẠNH PHÚC - BÁN THUỐC\n' +
                '═══════════════════════════════════════\n\n' +
                'Mã hóa đơn: ' + data.billId + '\n' +
                'Ngày: ' + new Date().toLocaleString('vi-VN') + '\n' +
                'Nhân viên: ' + staffName + '\n\n' +
                '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n' +
                'Khách hàng: ' + data.customerName + '\n\n' +
                '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n' +
                'CHI TIẾT THUỐC:\n' + details +
                '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n' +
                'TỔNG CỘNG: ' + data.totalAmount.toLocaleString('vi-VN') + ' VNĐ\n' +
                'Phương thức: ' + (data.paymentMethod || 'Tiền mặt') + '\n' +
                'Trạng thái: ✅ ĐÃ THANH TOÁN\n\n' +
                '═══════════════════════════════════════\n' +
                '           CẢM ƠN QUÝ KHÁCH!\n' +
                '═══════════════════════════════════════';

            document.getElementById('billContent').textContent = billText;
            new bootstrap.Modal(document.getElementById('billModal')).show();
                                    }

                                    function printBill() {
                                        const billContent = document.getElementById('billContent').textContent;
                                        const printWindow = window.open('', '', 'height=600,width=800');
            printWindow.document.write('<html><head><title>Hóa đơn</title><style>body{font-family:monospace;white-space:pre-line;padding:20px;}</style></head><body>' + billContent + '</body></html>');
                                        printWindow.document.close();
                                        printWindow.print();
                                    }

                                    function newSale() {
                                        cart = {};
                                        document.querySelectorAll('.medicine-card').forEach(card => {
                card.classList.remove('selected');
                                        });
                                        document.getElementById('customerName').value = '';
                                        document.getElementById('searchInput').value = '';
            document.querySelectorAll('.payment-btn').forEach(btn => btn.classList.remove('active'));
            document.querySelector('[data-method="CASH"]').classList.add('active');
                                        selectedPaymentMethod = 'CASH';
                                        updateCart();
            bootstrap.Modal.getInstance(document.getElementById('billModal')).hide();
                                    }
                                </script>
                            </body>
                            </html>
