// lib/utils/mock_data.dart

/// Mock Data สำหรับทั้งระบบ (นำไปใช้ได้ทุกหน้า)
library;

//// =========== Employee (พนักงาน) =============
List<Map<String, dynamic>> mockEmployeeList = [
  {
    "empId": "EMP001",
    "name": "ศิริพร ใจดี",
    "nickname": "ฝ้าย",
    "level": "Senior",
    "position": "HR Manager",
    "department": "D001",
    "email": "faijai@gmail.com",
    "phone": "0812345678",
    "profilePic": "https://i.pravatar.cc/300?img=5",
    "password": "123456",
    "startDate": "2020-01-20", // วันที่เริ่มงาน
  },
  {
    "empId": "EMP002",
    "name": "อนันต์ อาจดี",
    "nickname": "นัท",
    "level": "Staff",
    "position": "Programmer",
    "department": "D002",
    "email": "anan@gmail.com",
    "phone": "0898765432",
    "profilePic": "https://i.pravatar.cc/300?img=2",
    "password": "654321",
    "startDate": "2020-01-20", // วันที่เริ่มงาน
  },
  {
    "empId": "EMP003",
    "name": "สุธา อาจดี",
    "nickname": "สุธา",
    "level": "Staff",
    "position": "Project Manager",
    "department": "D003",
    "email": "sutha@gmail.com",
    "phone": "0898765432",
    "profilePic": "https://i.pravatar.cc/300?img=3",
    "password": "654321",
    "startDate": "2020-01-20", // วันที่เริ่มงาน
  },
  {
    "empId": "EMP004",
    "name": "สุธา อาจดี",
    "nickname": "สุธา",
    "level": "Staff",
    "position": "Programmer",
    "department": "D002",
    "email": "sutha@gmail.com",
    "phone": "0898765432",
    "profilePic": "https://i.pravatar.cc/300?img=3",
    "password": "654321",
    "startDate": "2020-01-20", // วันที่เริ่มงาน
  },
];

//// =========== PRODUCT (สินค้า) =============
List<Map<String, dynamic>> mockProductList = [
  {"code": "P001", "name": "สมุดโน๊ต A5", "qty": 50, "unit": "เล่ม", "min": 10},
  {"code": "P002", "name": "ปากกาเจล", "qty": 12, "unit": "ด้าม", "min": 20},
  {"code": "P003", "name": "น้ำดื่ม", "qty": 5, "unit": "ขวด", "min": 5},
  {"code": "P004", "name": "ดินสอ", "qty": 70, "unit": "แท่ง", "min": 30},
  {"code": "P005", "name": "แฟ้มเอกสาร", "qty": 35, "unit": "อัน", "min": 10},
];

/// =========== PURCHASE ORDER (PO) (12 เดือน) ============
List<Map<String, dynamic>> mockPOList = [
  for (int i = 1; i <= 12; i++)
    {
      "poNo": "PO-2400${i.toString().padLeft(2, '0')}",
      "date": "2024-${i.toString().padLeft(2, '0')}-10",
      "supplier": "S00${(i % 2) + 1}",
      "warehouse": "W001",
      "status": i % 4 == 0 ? "ยกเลิก" : (i % 3 == 0 ? "รอดำเนินการ" : "สำเร็จ"),
      "items": [
        {
          "product": "P00${(i % 5) + 1}",
          "qty": 3 + i,
          "unit": "ชิ้น",
          "price": 80.0 + (i * 10),
        },
      ],
      "total": 3000.0 + (i * 800),
    },
];

/// =========== SUPPLIER =============
List<Map<String, dynamic>> mockSupplierList = [
  {
    "code": "S001",
    "name": "บริษัท สมาร์ทซัพพลาย จำกัด",
    "phone": "086-111-2222",
    "email": "contact@smartsupply.co.th",
    "address": "12/34 ถ.สุขุมวิท บางนา กทม.",
    "remark": "VAT Registered",
  },
  {
    "code": "S002",
    "name": "รุ่งเรืองการค้า",
    "phone": "098-222-3333",
    "email": "rung@example.com",
    "address": "89/9 หมู่ 7 เชียงใหม่",
    "remark": "",
  },
];

/// =========== WAREHOUSE ============
List<Map<String, dynamic>> mockWarehouseList = [
  {
    "code": "W001",
    "name": "คลังหลัก",
    "location": "สำนักงานใหญ่",
    "remark": "คลังสินค้าหลักสำหรับบริษัท",
  },
  {"code": "W002", "name": "คลังสาขา 1", "location": "บางนา", "remark": ""},
  {"code": "W003", "name": "คลังสาขา 2", "location": "บางกรวย", "remark": ""},
];

/// =========== MOVEMENT LOG (ประวัติการเคลื่อนไหว) =============
List<Map<String, dynamic>> mockMovementList = [
  {
    "type": "IN",
    "date": "2024-06-19",
    "docNo": "IN-240001",
    "warehouse": "คลังหลัก",
    "product": "สมุดโน๊ต A5",
    "qty": 50,
    "unit": "เล่ม",
    "remark": "รับเข้า (สั่งซื้อ)",
  },
  {
    "type": "OUT",
    "date": "2024-06-18",
    "docNo": "OUT-240001",
    "warehouse": "คลังสาขา 1",
    "product": "น้ำดื่ม 600ml",
    "qty": 10,
    "unit": "ขวด",
    "remark": "เบิกใช้งานกิจกรรม",
  },
  {
    "type": "TRANSFER",
    "date": "2024-06-17",
    "docNo": "TRF-240001",
    "warehouse": "คลังหลัก → คลังสาขา 1",
    "product": "ปากกาเจล",
    "qty": 20,
    "unit": "ด้าม",
    "remark": "โอนย้ายคลัง",
  },
];

/// =========== AR (ลูกหนี้) ============
List<Map<String, dynamic>> mockARList = [
  {
    "arNo": "AR-240001",
    "date": "2024-03-01",
    "customer": "C001",
    "amount": 6500.0,
    "dueDate": "2024-03-30",
    "status": "ค้างรับ",
    "soNo": "SO-240003",
  },
  {
    "arNo": "AR-240002",
    "date": "2024-04-10",
    "customer": "C002",
    "amount": 4800.0,
    "dueDate": "2024-04-25",
    "status": "รับเงินแล้ว",
    "soNo": "SO-240004",
  },
];

/// =========== AP (เจ้าหนี้) ============
List<Map<String, dynamic>> mockAPList = [
  {
    "apNo": "AP-240001",
    "date": "2024-02-01",
    "supplier": "S001",
    "amount": 4000.0,
    "dueDate": "2024-02-28",
    "status": "ค้างจ่าย",
    "poNo": "PO-240002",
  },
  {
    "apNo": "AP-240002",
    "date": "2024-03-05",
    "supplier": "S002",
    "amount": 5200.0,
    "dueDate": "2024-04-01",
    "status": "จ่ายแล้ว",
    "poNo": "PO-240003",
  },
];

/// =========== CUSTOMER (ลูกค้า) =============
List<Map<String, dynamic>> mockCustomerList = [
  {
    "code": "C001",
    "name": "บริษัท ไทยเทค จำกัด",
    "phone": "081-123-4567",
    "email": "info@thaitech.co.th",
    "address": "123 หมู่ 5 ถ.พระราม 2 บางขุนเทียน กทม.",
    "remark": "กลุ่มลูกค้าหลัก",
  },
  {
    "code": "C002",
    "name": "ร้านโกลเด้นมาร์ท",
    "phone": "082-222-3333",
    "email": "goldenmart@gmail.com",
    "address": "50/88 ถ.สุขุมวิท พัทยา ชลบุรี",
    "remark": "",
  },
  {
    "code": "C003",
    "name": "บริษัท บิ๊กวัน จำกัด",
    "phone": "083-444-5555",
    "email": "contact@bigone.co.th",
    "address": "77/12 ถ.กิ่งแก้ว สมุทรปราการ",
    "remark": "ลูกค้าส่งประจำ",
  },
];

// sales & CRM
List<Map<String, dynamic>> mockQuotationList = [
  {
    "quotationNo": "QTN-240001",
    "date": "2024-06-20",
    "customerName": "บริษัท ไทยเทค จำกัด",
    "status": "รอดำเนินการ",
    "total": 3000.0,
    "items": [],
  },
];

/// =========== SALES ORDER (SO) (12 เดือน) ============
List<Map<String, dynamic>> mockSalesOrderList = [
  for (int i = 1; i <= 12; i++)
    {
      "soNo": "SO-2400${i.toString().padLeft(2, '0')}",
      "date": "2024-${i.toString().padLeft(2, '0')}-15",
      "customerCode": "C00${(i % 3) + 1}",
      "total": 8000.0 + (i * 1500),
      "status": i % 4 == 0 ? "ยกเลิก" : (i % 3 == 0 ? "รอดำเนินการ" : "สำเร็จ"),
      "items": [
        {
          "product": "P00${(i % 5) + 1}",
          "qty": 5 + i,
          "unit": "ชิ้น",
          "price": 100.0 + (i * 20),
        },
      ],
    },
];

/// รับสินค้าเข้าสต็อก (IN)
void receiveProduct(String code, int qty, String warehouse, String refNo) {
  final idx = mockProductList.indexWhere((p) => p["code"] == code);
  if (idx != -1) {
    mockProductList[idx]["qty"] += qty;
    mockMovementList.add({
      "date": DateTime.now().toIso8601String().substring(0, 10),
      "type": "IN",
      "product": code,
      "qty": qty,
      "warehouse": warehouse,
      "ref": refNo,
    });
  }
}

/// จ่ายสินค้าออกจากสต็อก (OUT)
bool issueProduct(String code, int qty, String warehouse, String refNo) {
  final idx = mockProductList.indexWhere((p) => p["code"] == code);
  if (idx != -1 && mockProductList[idx]["qty"] >= qty) {
    mockProductList[idx]["qty"] -= qty;
    mockMovementList.add({
      "date": DateTime.now().toIso8601String().substring(0, 10),
      "type": "OUT",
      "product": code,
      "qty": qty,
      "warehouse": warehouse,
      "ref": refNo,
    });
    return true;
  }
  return false;
}

/// โอนสินค้า (TRANSFER)
bool transferStock(String code, int qty, String fromWh, String toWh) {
  // สำหรับ demo: ระบบยังเป็น stock เดียว
  // หากต้องการแยก stock หลายคลัง ต้องแก้ data structure
  final idx = mockProductList.indexWhere((p) => p["code"] == code);
  if (idx != -1 && mockProductList[idx]["qty"] >= qty) {
    // ใน mock นี้ stock ลดฝั่งเดียว
    mockProductList[idx]["qty"] -= qty;
    // log transfer
    mockMovementList.add({
      "date": DateTime.now().toIso8601String().substring(0, 10),
      "type": "TRANSFER",
      "product": code,
      "qty": qty,
      "warehouse": "$fromWh → $toWh",
      "ref": "", // เพิ่ม ref ได้ตามต้องการ
    });
    return true;
  }
  return false;
}

/// ดูยอด stock สินค้าแต่ละตัว
int getStock(String code) {
  final idx = mockProductList.indexWhere((p) => p["code"] == code);
  return idx != -1 ? mockProductList[idx]["qty"] as int : 0;
}

/// ตรวจสอบว่าต่ำกว่าขั้นต่ำหรือไม่
bool isBelowMin(String code) {
  final idx = mockProductList.indexWhere((p) => p["code"] == code);
  if (idx != -1) {
    final qty = mockProductList[idx]["qty"] as int;
    final min = mockProductList[idx]["min"] as int;
    return qty < min;
  }
  return false;
}

/// ดึง movement log เฉพาะสินค้า (หรือทั้งหมด)
List<Map<String, dynamic>> getMovements({String? code}) {
  if (code == null) return mockMovementList;
  return mockMovementList.where((m) => m["product"] == code).toList();
}

/// =========== PROJECTS (โครงการ) =============
List<Map<String, dynamic>> mockProjectList = [
  {
    "id": "P001",
    "name": "ERP Implementation",
    "description": "ปรับใช้ระบบ ERP ครบวงจร",
    "responsible": "E001", // ผู้รับผิดชอบ id
    "departments": ["d01", "d03"],
    "members": ["E001", "E002"],
    "progress": 0.7,
    "tasks": [
      {"name": "Requirement Analysis", "completed": true},
      {"name": "System Setup", "completed": false},
      // ... เพิ่ม
    ],
    "comments": [
      {
        "user": "E002",
        "text": "เราต้องปรับ timeline ให้เร็วขึ้น",
        "createdAt": "2024-06-22 09:00",
      },
    ],
    "activitylog": [
      {"user": "E001", "action": "สร้างโครงการ", "date": "2024-06-21"},
    ],
  },
  // ... เพิ่ม project อื่นๆ
];

/// =========== DEPARTMENTS (แผนก) =============
final mockDepartmentList = [
  {"id": "D01", "name": "HR"},
  {"id": "D02", "name": "IT"},
  {"id": "D03", "name": "Design"},
  {"id": "D04", "name": "Sales"},
];
