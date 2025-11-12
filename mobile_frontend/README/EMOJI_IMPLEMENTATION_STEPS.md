# Emoji Implementation Steps

## Summary of Changes

The codebase has been refactored to use SVG file paths for emojis instead of emoji strings. All necessary files have been updated in both backend and frontend.

## Backend Changes

### ✅ Completed:
1. **Models Updated** (`app/models/`):
   - `categories.py` - Added `emoji_path` column
   - `accounts.py` - Added `emoji_path` column
   - `goals.py` - Added `emoji_path` column

2. **Schemas Updated** (`app/schemas/`):
   - `category.py` - Added `emoji_path` to Create, Update, and Read schemas
   - `account.py` - Added `emoji_path` to Create, Update, and Read schemas
   - `goal.py` - Added `emoji_path` to Create, Update, and Read schemas

3. **API Endpoints Updated** (`app/api/v1/`):
   - `categories.py` - Handles `emoji_path` in create and update
   - `accounts.py` - Handles `emoji_path` in create and update
   - `goals.py` - Handles `emoji_path` in create and update

4. **Database Migration Created**:
   - `app/alembic/versions/20251109_add_emoji_path.py` - Migration to add `emoji_path` columns

## Frontend Changes

### ✅ Completed:
1. **Models Updated**:
   - `category.dart` - Changed `emoji` to `emoji_path`
   - `account.dart` - Changed `emoji` to `emoji_path`
   - `goal.dart` - Changed `emoji` to `emoji_path` (with `@JsonKey`)

2. **Request Models Updated**:
   - All Create/Update request models now use `emoji_path`

3. **Cubits Updated**:
   - `CategoryCubit` - `setEmoji()` → `setEmojiPath()`, state uses `emoji_path`
   - `AccountCubit` - `setEmoji()` → `setEmojiPath()`, state uses `emoji_path`
   - `AddGoalCubit` - `setEmoji()` → `setEmojiPath()`, state uses `emoji_path`
   - `GoalsCubit` - `create()` and `update()` use `emoji_path` parameter

4. **UI Components Updated**:
   - `CategoryItem` - Displays SVG from `emoji_path` instead of emoji text
   - `BudgetBottomSheetSelector` - Displays SVG from emoji path
   - `TransactionAccountDropdown` - Uses `emoji_path` from account
   - `TransactionCategoryGrid` - Uses `emoji_path` from category
   - `EmojiPickerButton` - Displays SVG if path provided, otherwise shows emoji icon
   - `EmojiPickerModal` - Prepared to show SVG files (currently shows emoji strings as fallback)

5. **Modals Updated**:
   - All add/edit modals now use `emoji_path` instead of `emoji`

6. **Assets Directory**:
   - Created `assets/emoji/` directory
   - Added to `pubspec.yaml` assets list

## Next Steps (After Emoji SVG Files Are Provided)

### 1. Add Emoji SVG Files
   - Place all emoji SVG files in `mobile_frontend/assets/emoji/`
   - Recommended naming: descriptive names like `money.svg`, `food.svg`, `transport.svg`, etc.

### 2. Update Emoji Picker Modal
   - Open `mobile_frontend/lib/core/widgets/emoji_picker/emoji_picker_modal.dart`
   - Update the `_emojiPaths` list (around line 93) with actual SVG file paths:
     ```dart
     static const List<String> _emojiPaths = [
       'assets/emoji/money.svg',
       'assets/emoji/food.svg',
       'assets/emoji/transport.svg',
       // ... add all your emoji SVG file paths
     ];
     ```
   - Remove or comment out the `_emojis` fallback list once SVG files are added

### 3. Set Default Emoji Path
   - Update `transaction_category_grid.dart` line 45:
     - Change `defaultEmoji: 'assets/emoji/default_category.svg'` to your actual default SVG file path

### 4. Run Database Migration
   ```bash
   cd app
   alembic upgrade head
   ```

### 5. Regenerate Frontend Code (if needed)
   ```bash
   cd mobile_frontend
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
   Note: The retrofit_generator error is a known issue and can be ignored if it doesn't affect your API client generation.

### 6. Test the Implementation
   - Test creating accounts, categories, and goals with emoji paths
   - Verify emojis display correctly in all widgets
   - Test editing existing items with emoji paths

## File Structure

```
mobile_frontend/assets/emoji/     ← Place SVG files here
app/alembic/versions/             ← Migration file created
```

## Important Notes

- The `emoji_path` field stores the full path to the SVG file (e.g., `"assets/emoji/money.svg"`)
- All widgets now load SVG files using `SvgPicture.asset()` instead of displaying emoji text
- The emoji picker currently shows emoji strings as a fallback until SVG files are provided
- Once SVG files are added, update the `_emojiPaths` list in `emoji_picker_modal.dart`

