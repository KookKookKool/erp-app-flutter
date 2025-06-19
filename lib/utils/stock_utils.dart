// lib/utils/stock_utils.dart

/// ========================
/// Stock Utils (Mockup)
/// ========================
library;

// ====================
// MOCK STOCK (สินค้า/สต็อกหลักเดียว)
// ====================

/// สินค้าในระบบ (mock)
List<Map<String, dynamic>> productStock = [
  {"code": "P001", "name": "สมุดโน๊ต A5", "qty": 50, "min": 10},
  {"code": "P002", "name": "ปากกาเจล", "qty": 100, "min": 20},
  {"code": "P003", "name": "น้ำดื่ม", "qty": 30, "min": 5},
];

/// Movement log — ประวัติ IN/OUT/TRANSFER
List<Map<String, dynamic>> movementLog = [
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

// ====================
// STOCK UTILS
// ====================

/// รับสินค้าเข้าสต็อก (IN)
void receiveProduct(String code, int qty, String warehouse, String refNo) {
  final idx = productStock.indexWhere((p) => p["code"] == code);
  if (idx != -1) {
    productStock[idx]["qty"] += qty;
    movementLog.add({
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
  final idx = productStock.indexWhere((p) => p["code"] == code);
  if (idx != -1 && productStock[idx]["qty"] >= qty) {
    productStock[idx]["qty"] -= qty;
    movementLog.add({
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
  final idx = productStock.indexWhere((p) => p["code"] == code);
  if (idx != -1 && productStock[idx]["qty"] >= qty) {
    // ใน mock นี้ stock ลดฝั่งเดียว
    productStock[idx]["qty"] -= qty;
    // log transfer
    movementLog.add({
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
  final idx = productStock.indexWhere((p) => p["code"] == code);
  return idx != -1 ? productStock[idx]["qty"] as int : 0;
}

/// ตรวจสอบว่าต่ำกว่าขั้นต่ำหรือไม่
bool isBelowMin(String code) {
  final idx = productStock.indexWhere((p) => p["code"] == code);
  if (idx != -1) {
    final qty = productStock[idx]["qty"] as int;
    final min = productStock[idx]["min"] as int;
    return qty < min;
  }
  return false;
}

/// ดึง movement log เฉพาะสินค้า (หรือทั้งหมด)
List<Map<String, dynamic>> getMovements({String? code}) {
  if (code == null) return movementLog;
  return movementLog.where((m) => m["product"] == code).toList();
}
