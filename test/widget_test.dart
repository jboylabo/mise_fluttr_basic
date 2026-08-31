import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mise_fluttr_basic/official_identification/official_identification_widget.dart';

void main() {
  group('OfficialIdentificationValidator', () {
    final validator = OfficialIdentificationValidator();

    test('factoryは同じインスタンスを返す', () {
      expect(identical(validator, OfficialIdentificationValidator()), isTrue);
    });

    test('正しい電話番号ならtrueを返す', () {
      expect(validator.isPhoneNumberValid('090-1234-5678'), isTrue);
      expect(validator.isPhoneNumberValid('03-1234-5678'), isTrue);
    });

    test('正しくない電話番号ならfalseを返す', () {
      expect(validator.isPhoneNumberValid('12345'), isFalse);
      expect(validator.isPhoneNumberValid(''), isFalse);
    });

    test('すべて入力済みの場合だけcompleteになる', () {
      expect(
        validator.isComplete(
          familyName: '山田',
          givenName: '太郎',
          phoneNumber: '090-1234-5678',
          birthDate: DateTime(1990),
          gender: Gender.unanswered,
        ),
        isTrue,
      );
      expect(
        validator.isComplete(
          familyName: '山田',
          givenName: '',
          phoneNumber: '090-1234-5678',
          birthDate: DateTime(1990),
          gender: Gender.unanswered,
        ),
        isFalse,
      );
    });
  });

  group('OfficialIdentificationWidget', () {
    testWidgets('必要な入力項目と画像を表示する', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: OfficialIdentificationWidget()),
      );
      expect(find.byType(Image), findsOneWidget);
      for (final text in [
        '名字',
        '名前',
        '電話番号',
        '生年月日',
        '年齢',
        '性別',
        '男性',
        '女性',
        'その他',
        '回答しない',
      ]) {
        expect(find.text(text), findsOneWidget);
      }
    });

    testWidgets('未入力で確認するとエラーを表示する', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: OfficialIdentificationWidget()),
      );
      await tester.ensureVisible(find.byKey(const Key('submitButton')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('submitButton')));
      await tester.pump();
      for (final text in [
        '名字を入力してください',
        '名前を入力してください',
        '正しい電話番号を入力してください',
        '生年月日を選択してください',
        '性別を選択してください',
      ]) {
        expect(find.text(text), findsOneWidget);
      }
    });
  });
}
