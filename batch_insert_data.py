#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
批量数据插入脚本
用于向 sports_arena 数据库批量插入场地、器材和访客申请数据
"""

import mysql.connector
from datetime import date, timedelta
import random

# ========================================
# 数据库配置参数（请根据实际情况修改）
# ========================================
DB_CONFIG = {
    'host': 'localhost',
    'port': 3306,
    'user': 'root',
    'password': '',  # 请修改为实际密码
    'database': 'sports_arena',
    'charset': 'utf8mb4'
}

# ========================================
# Batch Insert Configuration
# ========================================
BATCH_CONFIG = {
    # Facility configuration
    'facility': {
        'count': 10,  # Number of records to insert
        'name_prefix': 'Facility',  # Name prefix
        'types': ['Basketball Court', 'Badminton Court', 'Tennis Court', 'Swimming Pool', 'Gym', 'Yoga Studio', 'Table Tennis Room'],
        'statuses': ['Available', 'Occupied', 'Maintenance'],
        'buildings': ['Sports Hall A', 'Sports Hall B', 'Main Building', 'Activity Center'],
        'capacity_range': (10, 100),  # Capacity range
        'floor_range': (1, 5),  # Floor range
    },
    
    # Equipment configuration
    'equipment': {
        'count': 15,  # Number of records to insert
        'name_prefix': 'Equipment',  # Name prefix
        'types': ['Ball Sports', 'Fitness Gear', 'Aquatic Gear', 'Protective Gear', 'Measuring Device', 'Training Aid'],
        'statuses': ['Available', 'In Use', 'Maintenance', 'Retired'],
        'quantity_range': (5, 50),  # Quantity range
    },
    
    # Visitor application configuration
    'visitor_application': {
        'count': 8,  # Number of records to insert
        'first_name_prefix': 'Visitor',  # First name prefix
        'last_names': ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis', 'Wilson', 'Taylor'],
        'statuses': ['Pending'],
        'ic_prefix': 'IC',  # IC number prefix
    },
}


def get_db_connection():
    """获取数据库连接"""
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        print("✓ 数据库连接成功")
        return conn
    except mysql.connector.Error as err:
        print(f"✗ 数据库连接失败: {err}")
        raise


def insert_facilities(cursor, config):
    """批量插入场地数据"""
    print("\n正在插入场地数据...")
    
    count = config['count']
    inserted = 0
    
    for i in range(1, count + 1):
        name = f"{config['name_prefix']}{i}"
        facility_type = random.choice(config['types'])
        status = random.choice(config['statuses'])
        capacity = random.randint(*config['capacity_range'])
        building = random.choice(config['buildings'])
        floor = random.randint(*config['floor_range'])
        room_number = f"{floor}{str(i).zfill(2)}"
        
        sql = """
            INSERT INTO facility 
            (Facility_Name, Type, Status, Capacity, Building, Floor, Room_Number)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """
        try:
            cursor.execute(sql, (name, facility_type, status, capacity, building, floor, room_number))
            inserted += 1
            print(f"  ✓ 插入场地: {name} ({facility_type})")
        except mysql.connector.Error as err:
            print(f"  ✗ 插入场地 {name} 失败: {err}")
    
    return inserted


def insert_equipment(cursor, config):
    """批量插入器材数据"""
    print("\n正在插入器材数据...")
    
    count = config['count']
    inserted = 0
    
    for i in range(1, count + 1):
        name = f"{config['name_prefix']}{i}"
        equipment_type = random.choice(config['types'])
        status = random.choice(config['statuses'])
        quantity = random.randint(*config['quantity_range'])
        
        sql = """
            INSERT INTO equipment 
            (Equipment_Name, Type, Status, Total_Quantity)
            VALUES (%s, %s, %s, %s)
        """
        try:
            cursor.execute(sql, (name, equipment_type, status, quantity))
            inserted += 1
            print(f"  ✓ 插入器材: {name} ({equipment_type}, 数量: {quantity})")
        except mysql.connector.Error as err:
            print(f"  ✗ 插入器材 {name} 失败: {err}")
    
    return inserted


def insert_visitor_applications(cursor, config):
    """批量插入访客申请数据"""
    print("\n正在插入访客申请数据...")
    
    count = config['count']
    inserted = 0
    today = date.today()
    
    for i in range(1, count + 1):
        first_name = f"{config['first_name_prefix']}{i}"
        last_name = random.choice(config['last_names'])
        ic_number = f"{config['ic_prefix']}{str(i).zfill(8)}"
        application_date = today - timedelta(days=random.randint(0, 30))
        status = random.choice(config['statuses'])
        
        # 根据状态设置审批日期和拒绝原因
        approval_date = None
        reject_reason = None
        
        if status == 'Approved':
            approval_date = application_date + timedelta(days=random.randint(1, 7))
        elif status == 'Rejected':
            approval_date = application_date + timedelta(days=random.randint(1, 7))
            reject_reason = random.choice([
                'Incomplete documentation',
                'Identity verification failed', 
                'Falsified application materials',
                'Does not meet visitor eligibility'
            ])
        
        sql = """
            INSERT INTO visitor_application 
            (First_Name, Last_Name, IC_Number, Application_Date, Status, Approval_Date, Reject_Reason)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """
        try:
            cursor.execute(sql, (first_name, last_name, ic_number, application_date, 
                                status, approval_date, reject_reason))
            inserted += 1
            print(f"  ✓ 插入访客申请: {last_name}{first_name} (状态: {status})")
        except mysql.connector.Error as err:
            print(f"  ✗ 插入访客申请 {last_name}{first_name} 失败: {err}")
    
    return inserted


def main():
    """主函数"""
    print("=" * 50)
    print("批量数据插入脚本 - sports_arena 数据库")
    print("=" * 50)
    
    conn = None
    try:
        # 连接数据库
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # 统计结果
        results = {}
        
        # 批量插入场地
        results['facility'] = insert_facilities(cursor, BATCH_CONFIG['facility'])
        
        # 批量插入器材
        results['equipment'] = insert_equipment(cursor, BATCH_CONFIG['equipment'])
        
        # 批量插入访客申请
        results['visitor_application'] = insert_visitor_applications(
            cursor, BATCH_CONFIG['visitor_application']
        )
        
        # 提交事务
        conn.commit()
        
        # 打印汇总
        print("\n" + "=" * 50)
        print("插入完成汇总:")
        print("=" * 50)
        print(f"  场地 (Facility): {results['facility']} 条")
        print(f"  器材 (Equipment): {results['equipment']} 条")
        print(f"  访客申请 (Visitor Application): {results['visitor_application']} 条")
        print(f"  总计: {sum(results.values())} 条")
        print("=" * 50)
        
    except Exception as e:
        print(f"\n✗ 执行出错: {e}")
        if conn:
            conn.rollback()
            print("事务已回滚")
    finally:
        if conn:
            conn.close()
            print("\n数据库连接已关闭")


if __name__ == "__main__":
    main()
