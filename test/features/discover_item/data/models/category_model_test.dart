import 'package:rateeat_mobile/src/features/discover_item/data/models/catagory_model.dart';
import 'package:test/test.dart';

void main() {
  group('Item Tests', () {
    test('Item creation and properties', () {
      final item = Item(id: 'item1');
      expect(item.id, 'item1');
    });

    test('Item fromJson', () {
      final json = {'id': 'item1'};
      final item = Item.fromJson(json);
      expect(item.id, 'item1');
    });

    test('Item toJson', () {
      final item = Item(id: 'item1');
      final json = item.toJson();
      expect(json, {'id': 'item1'});
    });
  });

  group('Category Tests', () {
    test('Category creation and properties', () {
      final items = [Item(id: 'item1'), Item(id: 'item2')];
      final category = Category(
        id: 'cat1',
        name: 'Test Category',
        isApproved: true,
        menuId: 'menu1',
        createdAt: '2023-01-01',
        updatedAt: '2023-01-02',
        item: items,
        totalItems: 2,
      );

      expect(category.id, 'cat1');
      expect(category.name, 'Test Category');
      expect(category.isApproved, true);
      expect(category.menuId, 'menu1');
      expect(category.createdAt, '2023-01-01');
      expect(category.updatedAt, '2023-01-02');
      expect(category.item.length, 2);
      expect(category.totalItems, 2);
    });

    test('Category fromJson', () {
      final json = {
        'id': 'cat1',
        'name': 'Test Category',
        'is_approved': true,
        'menu_id': 'menu1',
        'createdAt': '2023-01-01',
        'updatedAt': '2023-01-02',
        'item': [
          {'id': 'item1'},
          {'id': 'item2'}
        ],
        'total_items': 2,
      };

      final category = Category.fromJson(json);
      expect(category.id, 'cat1');
      expect(category.name, 'Test Category');
      expect(category.isApproved, true);
      expect(category.item.length, 2);
      expect(category.item[0].id, 'item1');
      expect(category.totalItems, 2);
    });

    test('Category toJson', () {
      final items = [Item(id: 'item1'), Item(id: 'item2')];
      final category = Category(
        id: 'cat1',
        name: 'Test Category',
        isApproved: true,
        menuId: 'menu1',
        createdAt: '2023-01-01',
        updatedAt: '2023-01-02',
        item: items,
        totalItems: 2,
      );

      final json = category.toJson();
      expect(json['id'], 'cat1');
      expect(json['is_approved'], true);
      expect((json['item'] as List).length, 2);
      expect(json['total_items'], 2);
    });
  });

  group('CategoryModel Tests', () {
    test('CategoryModel creation and properties', () {
      final categories = [
        Category(
          id: 'cat1',
          name: 'Test Category',
          isApproved: true,
          menuId: 'menu1',
          createdAt: '2023-01-01',
          updatedAt: '2023-01-02',
          item: [Item(id: 'item1')],
          totalItems: 1,
        )
      ];
      final model = CategoryModel(
        success: true,
        allMenuItems: 1,
        data: categories,
      );

      expect(model.success, true);
      expect(model.allMenuItems, 1);
      expect(model.data.length, 1);
    });

    test('CategoryModel fromJson', () {
      final json = {
        'success': true,
        'allMenuItems': 1,
        'data': [
          {
            'id': 'cat1',
            'name': 'Test Category',
            'is_approved': true,
            'menu_id': 'menu1',
            'createdAt': '2023-01-01',
            'updatedAt': '2023-01-02',
            'item': [
              {'id': 'item1'}
            ],
            'total_items': 1,
          }
        ]
      };

      final model = CategoryModel.fromJson(json);
      expect(model.success, true);
      expect(model.allMenuItems, 1);
      expect(model.data.length, 1);
      expect(model.data[0].item[0].id, 'item1');
    });

    test('CategoryModel toJson', () {
      final categories = [
        Category(
          id: 'cat1',
          name: 'Test Category',
          isApproved: true,
          menuId: 'menu1',
          createdAt: '2023-01-01',
          updatedAt: '2023-01-02',
          item: [Item(id: 'item1')],
          totalItems: 1,
        )
      ];
      final model = CategoryModel(
        success: true,
        allMenuItems: 1,
        data: categories,
      );

      final json = model.toJson();
      expect(json['success'], true);
      expect(json['allMenuItems'], 1);
      expect((json['data'] as List).length, 1);
    });
  });
}
