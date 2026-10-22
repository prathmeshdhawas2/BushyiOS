#import <Foundation/NSArray.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSError.h>
#import <Foundation/NSObject.h>
#import <Foundation/NSSet.h>
#import <Foundation/NSString.h>
#import <Foundation/NSValue.h>

@class SharedAnalysisMethod, SharedCalorieRange, SharedDishInterpretationResult, SharedEditableFoodItem, SharedIndianNutritionDatabase, SharedIndianNutritionEntry, SharedKotlinArray<T>, SharedKotlinEnum<E>, SharedKotlinEnumCompanion, SharedLanguageScript, SharedLanguageScriptCompanion, SharedLocalAiModel, SharedLocalAiModelCompanion, SharedMealAnalysisResult, SharedModelDownloadState, SharedModelDownloadStateDownloading, SharedModelDownloadStateError, SharedModelDownloadStateNotDownloaded, SharedModelDownloadStateReady, SharedMultilingualDishInterpreter, SharedNutrientBreakdown, SharedPortionUnit, SharedPortionUnitCompanion, SharedPrepStyle, SharedPrepStyleCompanion;

@protocol SharedKotlinComparable, SharedKotlinIterator;

NS_ASSUME_NONNULL_BEGIN
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunknown-warning-option"
#pragma clang diagnostic ignored "-Wincompatible-property-type"
#pragma clang diagnostic ignored "-Wnullability"

#pragma push_macro("_Nullable_result")
#if !__has_feature(nullability_nullable_result)
#undef _Nullable_result
#define _Nullable_result _Nullable
#endif

__attribute__((swift_name("KotlinBase")))
@interface SharedBase : NSObject
- (instancetype)init __attribute__((unavailable));
+ (instancetype)new __attribute__((unavailable));
+ (void)initialize __attribute__((objc_requires_super));
@end

@interface SharedBase (SharedBaseCopying) <NSCopying>
@end

__attribute__((swift_name("KotlinMutableSet")))
@interface SharedMutableSet<ObjectType> : NSMutableSet<ObjectType>
@end

__attribute__((swift_name("KotlinMutableDictionary")))
@interface SharedMutableDictionary<KeyType, ObjectType> : NSMutableDictionary<KeyType, ObjectType>
@end

@interface NSError (NSErrorSharedKotlinException)
@property (readonly) id _Nullable kotlinException;
@end

__attribute__((swift_name("KotlinNumber")))
@interface SharedNumber : NSNumber
- (instancetype)initWithChar:(char)value __attribute__((unavailable));
- (instancetype)initWithUnsignedChar:(unsigned char)value __attribute__((unavailable));
- (instancetype)initWithShort:(short)value __attribute__((unavailable));
- (instancetype)initWithUnsignedShort:(unsigned short)value __attribute__((unavailable));
- (instancetype)initWithInt:(int)value __attribute__((unavailable));
- (instancetype)initWithUnsignedInt:(unsigned int)value __attribute__((unavailable));
- (instancetype)initWithLong:(long)value __attribute__((unavailable));
- (instancetype)initWithUnsignedLong:(unsigned long)value __attribute__((unavailable));
- (instancetype)initWithLongLong:(long long)value __attribute__((unavailable));
- (instancetype)initWithUnsignedLongLong:(unsigned long long)value __attribute__((unavailable));
- (instancetype)initWithFloat:(float)value __attribute__((unavailable));
- (instancetype)initWithDouble:(double)value __attribute__((unavailable));
- (instancetype)initWithBool:(BOOL)value __attribute__((unavailable));
- (instancetype)initWithInteger:(NSInteger)value __attribute__((unavailable));
- (instancetype)initWithUnsignedInteger:(NSUInteger)value __attribute__((unavailable));
+ (instancetype)numberWithChar:(char)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedChar:(unsigned char)value __attribute__((unavailable));
+ (instancetype)numberWithShort:(short)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedShort:(unsigned short)value __attribute__((unavailable));
+ (instancetype)numberWithInt:(int)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedInt:(unsigned int)value __attribute__((unavailable));
+ (instancetype)numberWithLong:(long)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedLong:(unsigned long)value __attribute__((unavailable));
+ (instancetype)numberWithLongLong:(long long)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedLongLong:(unsigned long long)value __attribute__((unavailable));
+ (instancetype)numberWithFloat:(float)value __attribute__((unavailable));
+ (instancetype)numberWithDouble:(double)value __attribute__((unavailable));
+ (instancetype)numberWithBool:(BOOL)value __attribute__((unavailable));
+ (instancetype)numberWithInteger:(NSInteger)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedInteger:(NSUInteger)value __attribute__((unavailable));
@end

__attribute__((swift_name("KotlinByte")))
@interface SharedByte : SharedNumber
- (instancetype)initWithChar:(char)value;
+ (instancetype)numberWithChar:(char)value;
@end

__attribute__((swift_name("KotlinUByte")))
@interface SharedUByte : SharedNumber
- (instancetype)initWithUnsignedChar:(unsigned char)value;
+ (instancetype)numberWithUnsignedChar:(unsigned char)value;
@end

__attribute__((swift_name("KotlinShort")))
@interface SharedShort : SharedNumber
- (instancetype)initWithShort:(short)value;
+ (instancetype)numberWithShort:(short)value;
@end

__attribute__((swift_name("KotlinUShort")))
@interface SharedUShort : SharedNumber
- (instancetype)initWithUnsignedShort:(unsigned short)value;
+ (instancetype)numberWithUnsignedShort:(unsigned short)value;
@end

__attribute__((swift_name("KotlinInt")))
@interface SharedInt : SharedNumber
- (instancetype)initWithInt:(int)value;
+ (instancetype)numberWithInt:(int)value;
@end

__attribute__((swift_name("KotlinUInt")))
@interface SharedUInt : SharedNumber
- (instancetype)initWithUnsignedInt:(unsigned int)value;
+ (instancetype)numberWithUnsignedInt:(unsigned int)value;
@end

__attribute__((swift_name("KotlinLong")))
@interface SharedLong : SharedNumber
- (instancetype)initWithLongLong:(long long)value;
+ (instancetype)numberWithLongLong:(long long)value;
@end

__attribute__((swift_name("KotlinULong")))
@interface SharedULong : SharedNumber
- (instancetype)initWithUnsignedLongLong:(unsigned long long)value;
+ (instancetype)numberWithUnsignedLongLong:(unsigned long long)value;
@end

__attribute__((swift_name("KotlinFloat")))
@interface SharedFloat : SharedNumber
- (instancetype)initWithFloat:(float)value;
+ (instancetype)numberWithFloat:(float)value;
@end

__attribute__((swift_name("KotlinDouble")))
@interface SharedDouble : SharedNumber
- (instancetype)initWithDouble:(double)value;
+ (instancetype)numberWithDouble:(double)value;
@end

__attribute__((swift_name("KotlinBoolean")))
@interface SharedBoolean : SharedNumber
- (instancetype)initWithBool:(BOOL)value;
+ (instancetype)numberWithBool:(BOOL)value;
@end

__attribute__((swift_name("KotlinComparable")))
@protocol SharedKotlinComparable
@required
- (int32_t)compareToOther:(id _Nullable)other __attribute__((swift_name("compareTo(other:)")));
@end

__attribute__((swift_name("KotlinEnum")))
@interface SharedKotlinEnum<E> : SharedBase <SharedKotlinComparable>
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SharedKotlinEnumCompanion *companion __attribute__((swift_name("companion")));
- (int32_t)compareToOther:(E)other __attribute__((swift_name("compareTo(other:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *name __attribute__((swift_name("name")));
@property (readonly) int32_t ordinal __attribute__((swift_name("ordinal")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("AnalysisMethod")))
@interface SharedAnalysisMethod : SharedKotlinEnum<SharedAnalysisMethod *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly) SharedAnalysisMethod *localHeuristicColorFeature __attribute__((swift_name("localHeuristicColorFeature")));
@property (class, readonly) SharedAnalysisMethod *localQwenVlmPlaceholder __attribute__((swift_name("localQwenVlmPlaceholder")));
@property (class, readonly) SharedAnalysisMethod *manualEntry __attribute__((swift_name("manualEntry")));
+ (SharedKotlinArray<SharedAnalysisMethod *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<SharedAnalysisMethod *> *entries __attribute__((swift_name("entries")));
@property (readonly) NSString *description_ __attribute__((swift_name("description_")));
@property (readonly) NSString *displayName __attribute__((swift_name("displayName")));
@property (readonly) BOOL isLocalAiModel __attribute__((swift_name("isLocalAiModel")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("CalorieRange")))
@interface SharedCalorieRange : SharedBase
- (instancetype)initWithMinCalories:(int32_t)minCalories maxCalories:(int32_t)maxCalories assumptionsNote:(NSString *)assumptionsNote __attribute__((swift_name("init(minCalories:maxCalories:assumptionsNote:)"))) __attribute__((objc_designated_initializer));
- (SharedCalorieRange *)doCopyMinCalories:(int32_t)minCalories maxCalories:(int32_t)maxCalories assumptionsNote:(NSString *)assumptionsNote __attribute__((swift_name("doCopy(minCalories:maxCalories:assumptionsNote:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *assumptionsNote __attribute__((swift_name("assumptionsNote")));
@property (readonly) int32_t maxCalories __attribute__((swift_name("maxCalories")));
@property (readonly) int32_t minCalories __attribute__((swift_name("minCalories")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("DishInterpretationResult")))
@interface SharedDishInterpretationResult : SharedBase
- (instancetype)initWithOriginalInput:(NSString *)originalInput normalizedName:(NSString *)normalizedName script:(SharedLanguageScript *)script confidenceScore:(float)confidenceScore bestMatch:(SharedIndianNutritionEntry * _Nullable)bestMatch candidateMatches:(NSArray<SharedIndianNutritionEntry *> *)candidateMatches suggestedCorrection:(NSString * _Nullable)suggestedCorrection isAmbiguous:(BOOL)isAmbiguous __attribute__((swift_name("init(originalInput:normalizedName:script:confidenceScore:bestMatch:candidateMatches:suggestedCorrection:isAmbiguous:)"))) __attribute__((objc_designated_initializer));
- (SharedDishInterpretationResult *)doCopyOriginalInput:(NSString *)originalInput normalizedName:(NSString *)normalizedName script:(SharedLanguageScript *)script confidenceScore:(float)confidenceScore bestMatch:(SharedIndianNutritionEntry * _Nullable)bestMatch candidateMatches:(NSArray<SharedIndianNutritionEntry *> *)candidateMatches suggestedCorrection:(NSString * _Nullable)suggestedCorrection isAmbiguous:(BOOL)isAmbiguous __attribute__((swift_name("doCopy(originalInput:normalizedName:script:confidenceScore:bestMatch:candidateMatches:suggestedCorrection:isAmbiguous:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SharedIndianNutritionEntry * _Nullable bestMatch __attribute__((swift_name("bestMatch")));
@property (readonly) NSArray<SharedIndianNutritionEntry *> *candidateMatches __attribute__((swift_name("candidateMatches")));
@property (readonly) float confidenceScore __attribute__((swift_name("confidenceScore")));
@property (readonly) BOOL isAmbiguous __attribute__((swift_name("isAmbiguous")));
@property (readonly) NSString *normalizedName __attribute__((swift_name("normalizedName")));
@property (readonly) NSString *originalInput __attribute__((swift_name("originalInput")));
@property (readonly) SharedLanguageScript *script __attribute__((swift_name("script")));
@property (readonly) NSString * _Nullable suggestedCorrection __attribute__((swift_name("suggestedCorrection")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("EditableFoodItem")))
@interface SharedEditableFoodItem : SharedBase
- (instancetype)initWithId:(NSString *)id foodName:(NSString *)foodName confidenceScore:(float)confidenceScore quantity:(float)quantity unit:(SharedPortionUnit *)unit prepStyle:(SharedPrepStyle *)prepStyle caloriesPer100g:(int32_t)caloriesPer100g proteinPer100g:(float)proteinPer100g carbsPer100g:(float)carbsPer100g fatPer100g:(float)fatPer100g preparationNote:(NSString *)preparationNote originalUserText:(NSString * _Nullable)originalUserText detectedScript:(NSString * _Nullable)detectedScript __attribute__((swift_name("init(id:foodName:confidenceScore:quantity:unit:prepStyle:caloriesPer100g:proteinPer100g:carbsPer100g:fatPer100g:preparationNote:originalUserText:detectedScript:)"))) __attribute__((objc_designated_initializer));
- (SharedEditableFoodItem *)doCopyId:(NSString *)id foodName:(NSString *)foodName confidenceScore:(float)confidenceScore quantity:(float)quantity unit:(SharedPortionUnit *)unit prepStyle:(SharedPrepStyle *)prepStyle caloriesPer100g:(int32_t)caloriesPer100g proteinPer100g:(float)proteinPer100g carbsPer100g:(float)carbsPer100g fatPer100g:(float)fatPer100g preparationNote:(NSString *)preparationNote originalUserText:(NSString * _Nullable)originalUserText detectedScript:(NSString * _Nullable)detectedScript __attribute__((swift_name("doCopy(id:foodName:confidenceScore:quantity:unit:prepStyle:caloriesPer100g:proteinPer100g:carbsPer100g:fatPer100g:preparationNote:originalUserText:detectedScript:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SharedNutrientBreakdown *calculatedNutrients __attribute__((swift_name("calculatedNutrients")));
@property (readonly) int32_t caloriesPer100g __attribute__((swift_name("caloriesPer100g")));
@property (readonly) float carbsPer100g __attribute__((swift_name("carbsPer100g")));
@property (readonly) float confidenceScore __attribute__((swift_name("confidenceScore")));
@property (readonly) NSString * _Nullable detectedScript __attribute__((swift_name("detectedScript")));
@property (readonly) float fatPer100g __attribute__((swift_name("fatPer100g")));
@property (readonly) NSString *foodName __attribute__((swift_name("foodName")));
@property (readonly) NSString *id __attribute__((swift_name("id")));
@property (readonly) NSString * _Nullable originalUserText __attribute__((swift_name("originalUserText")));
@property (readonly) SharedPrepStyle *prepStyle __attribute__((swift_name("prepStyle")));
@property (readonly) NSString *preparationNote __attribute__((swift_name("preparationNote")));
@property (readonly) float proteinPer100g __attribute__((swift_name("proteinPer100g")));
@property (readonly) float quantity __attribute__((swift_name("quantity")));
@property (readonly) float totalWeightGrams __attribute__((swift_name("totalWeightGrams")));
@property (readonly) SharedPortionUnit *unit __attribute__((swift_name("unit")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("IndianNutritionDatabase")))
@interface SharedIndianNutritionDatabase : SharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)indianNutritionDatabase __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SharedIndianNutritionDatabase *shared __attribute__((swift_name("shared")));
- (void)addCustomEntryEntry:(SharedIndianNutritionEntry *)entry __attribute__((swift_name("addCustomEntry(entry:)")));
- (SharedEditableFoodItem *)createEditableFoodItemEntry:(SharedIndianNutritionEntry *)entry quantity:(float)quantity __attribute__((swift_name("createEditableFoodItem(entry:quantity:)")));
- (SharedIndianNutritionEntry *)findMatchingEntryQuery:(NSString *)query __attribute__((swift_name("findMatchingEntry(query:)")));
- (NSArray<SharedIndianNutritionEntry *> *)searchEntriesQuery:(NSString *)query __attribute__((swift_name("searchEntries(query:)")));
@property (readonly) NSArray<SharedIndianNutritionEntry *> *defaultItems __attribute__((swift_name("defaultItems")));
@property (readonly) NSArray<SharedIndianNutritionEntry *> *items __attribute__((swift_name("items")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("IndianNutritionEntry")))
@interface SharedIndianNutritionEntry : SharedBase
- (instancetype)initWithId:(NSString *)id name:(NSString *)name aliases:(NSArray<NSString *> *)aliases caloriesPer100g:(int32_t)caloriesPer100g proteinPer100g:(float)proteinPer100g carbsPer100g:(float)carbsPer100g fatPer100g:(float)fatPer100g defaultUnit:(SharedPortionUnit *)defaultUnit defaultUnitWeightGrams:(float)defaultUnitWeightGrams prepNotes:(NSString *)prepNotes regionOrCategory:(NSString *)regionOrCategory source:(NSString *)source __attribute__((swift_name("init(id:name:aliases:caloriesPer100g:proteinPer100g:carbsPer100g:fatPer100g:defaultUnit:defaultUnitWeightGrams:prepNotes:regionOrCategory:source:)"))) __attribute__((objc_designated_initializer));
- (SharedIndianNutritionEntry *)doCopyId:(NSString *)id name:(NSString *)name aliases:(NSArray<NSString *> *)aliases caloriesPer100g:(int32_t)caloriesPer100g proteinPer100g:(float)proteinPer100g carbsPer100g:(float)carbsPer100g fatPer100g:(float)fatPer100g defaultUnit:(SharedPortionUnit *)defaultUnit defaultUnitWeightGrams:(float)defaultUnitWeightGrams prepNotes:(NSString *)prepNotes regionOrCategory:(NSString *)regionOrCategory source:(NSString *)source __attribute__((swift_name("doCopy(id:name:aliases:caloriesPer100g:proteinPer100g:carbsPer100g:fatPer100g:defaultUnit:defaultUnitWeightGrams:prepNotes:regionOrCategory:source:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSArray<NSString *> *aliases __attribute__((swift_name("aliases")));
@property (readonly) int32_t caloriesPer100g __attribute__((swift_name("caloriesPer100g")));
@property (readonly) float carbsPer100g __attribute__((swift_name("carbsPer100g")));
@property (readonly) SharedPortionUnit *defaultUnit __attribute__((swift_name("defaultUnit")));
@property (readonly) float defaultUnitWeightGrams __attribute__((swift_name("defaultUnitWeightGrams")));
@property (readonly) float fatPer100g __attribute__((swift_name("fatPer100g")));
@property (readonly) NSString *id __attribute__((swift_name("id")));
@property (readonly) NSString *name __attribute__((swift_name("name")));
@property (readonly) NSString *prepNotes __attribute__((swift_name("prepNotes")));
@property (readonly) float proteinPer100g __attribute__((swift_name("proteinPer100g")));
@property (readonly) NSString *regionOrCategory __attribute__((swift_name("regionOrCategory")));
@property (readonly) NSString *source __attribute__((swift_name("source")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("LanguageScript")))
@interface SharedLanguageScript : SharedKotlinEnum<SharedLanguageScript *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) SharedLanguageScriptCompanion *companion __attribute__((swift_name("companion")));
@property (class, readonly) SharedLanguageScript *devanagari __attribute__((swift_name("devanagari")));
@property (class, readonly) SharedLanguageScript *bengali __attribute__((swift_name("bengali")));
@property (class, readonly) SharedLanguageScript *tamil __attribute__((swift_name("tamil")));
@property (class, readonly) SharedLanguageScript *telugu __attribute__((swift_name("telugu")));
@property (class, readonly) SharedLanguageScript *gujarati __attribute__((swift_name("gujarati")));
@property (class, readonly) SharedLanguageScript *kannada __attribute__((swift_name("kannada")));
@property (class, readonly) SharedLanguageScript *malayalam __attribute__((swift_name("malayalam")));
@property (class, readonly) SharedLanguageScript *gurmukhi __attribute__((swift_name("gurmukhi")));
@property (class, readonly) SharedLanguageScript *latinEnglish __attribute__((swift_name("latinEnglish")));
+ (SharedKotlinArray<SharedLanguageScript *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<SharedLanguageScript *> *entries __attribute__((swift_name("entries")));
@property (readonly) NSString *displayName __attribute__((swift_name("displayName")));
@property (readonly) NSString *languageName __attribute__((swift_name("languageName")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("LanguageScript.Companion")))
@interface SharedLanguageScriptCompanion : SharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SharedLanguageScriptCompanion *shared __attribute__((swift_name("shared")));
- (SharedLanguageScript *)detectScriptText:(NSString *)text __attribute__((swift_name("detectScript(text:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("LocalAiModel")))
@interface SharedLocalAiModel : SharedKotlinEnum<SharedLocalAiModel *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) SharedLocalAiModelCompanion *companion __attribute__((swift_name("companion")));
@property (class, readonly) SharedLocalAiModel *smollm360m __attribute__((swift_name("smollm360m")));
@property (class, readonly) SharedLocalAiModel *qwen05b __attribute__((swift_name("qwen05b")));
+ (SharedKotlinArray<SharedLocalAiModel *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<SharedLocalAiModel *> *entries __attribute__((swift_name("entries")));
@property (readonly) NSString *description_ __attribute__((swift_name("description_")));
@property (readonly) NSString *displayName __attribute__((swift_name("displayName")));
@property (readonly) NSString *downloadUrl __attribute__((swift_name("downloadUrl")));
@property (readonly) NSString *id __attribute__((swift_name("id")));
@property (readonly) BOOL isLocal __attribute__((swift_name("isLocal")));
@property (readonly) NSString *ramRequirement __attribute__((swift_name("ramRequirement")));
@property (readonly) int32_t sizeMb __attribute__((swift_name("sizeMb")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("LocalAiModel.Companion")))
@interface SharedLocalAiModelCompanion : SharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SharedLocalAiModelCompanion *shared __attribute__((swift_name("shared")));
- (SharedLocalAiModel *)fromIdId:(NSString *)id __attribute__((swift_name("fromId(id:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MealAnalysisResult")))
@interface SharedMealAnalysisResult : SharedBase
- (instancetype)initWithMealName:(NSString *)mealName items:(NSArray<SharedEditableFoodItem *> *)items analysisMethod:(SharedAnalysisMethod *)analysisMethod isFoodDetected:(BOOL)isFoodDetected detectionWarning:(NSString * _Nullable)detectionWarning timestamp:(int64_t)timestamp __attribute__((swift_name("init(mealName:items:analysisMethod:isFoodDetected:detectionWarning:timestamp:)"))) __attribute__((objc_designated_initializer));
- (SharedMealAnalysisResult *)doCopyMealName:(NSString *)mealName items:(NSArray<SharedEditableFoodItem *> *)items analysisMethod:(SharedAnalysisMethod *)analysisMethod isFoodDetected:(BOOL)isFoodDetected detectionWarning:(NSString * _Nullable)detectionWarning timestamp:(int64_t)timestamp __attribute__((swift_name("doCopy(mealName:items:analysisMethod:isFoodDetected:detectionWarning:timestamp:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SharedAnalysisMethod *analysisMethod __attribute__((swift_name("analysisMethod")));
@property (readonly) SharedCalorieRange *calorieRange __attribute__((swift_name("calorieRange")));
@property (readonly) NSString * _Nullable detectionWarning __attribute__((swift_name("detectionWarning")));
@property (readonly) BOOL isFoodDetected __attribute__((swift_name("isFoodDetected")));
@property (readonly) NSArray<SharedEditableFoodItem *> *items __attribute__((swift_name("items")));
@property (readonly) NSString *mealName __attribute__((swift_name("mealName")));
@property (readonly) int64_t timestamp __attribute__((swift_name("timestamp")));
@property (readonly) SharedNutrientBreakdown *totalNutrients __attribute__((swift_name("totalNutrients")));
@end

__attribute__((swift_name("ModelDownloadState")))
@interface SharedModelDownloadState : SharedBase
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ModelDownloadState.Downloading")))
@interface SharedModelDownloadStateDownloading : SharedModelDownloadState
- (instancetype)initWithProgressPercent:(int32_t)progressPercent __attribute__((swift_name("init(progressPercent:)"))) __attribute__((objc_designated_initializer));
- (SharedModelDownloadStateDownloading *)doCopyProgressPercent:(int32_t)progressPercent __attribute__((swift_name("doCopy(progressPercent:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) int32_t progressPercent __attribute__((swift_name("progressPercent")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ModelDownloadState.Error")))
@interface SharedModelDownloadStateError : SharedModelDownloadState
- (instancetype)initWithMessage:(NSString *)message __attribute__((swift_name("init(message:)"))) __attribute__((objc_designated_initializer));
- (SharedModelDownloadStateError *)doCopyMessage:(NSString *)message __attribute__((swift_name("doCopy(message:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *message __attribute__((swift_name("message")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ModelDownloadState.NotDownloaded")))
@interface SharedModelDownloadStateNotDownloaded : SharedModelDownloadState
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)notDownloaded __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SharedModelDownloadStateNotDownloaded *shared __attribute__((swift_name("shared")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ModelDownloadState.Ready")))
@interface SharedModelDownloadStateReady : SharedModelDownloadState
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)ready __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SharedModelDownloadStateReady *shared __attribute__((swift_name("shared")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MultilingualDishInterpreter")))
@interface SharedMultilingualDishInterpreter : SharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)multilingualDishInterpreter __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SharedMultilingualDishInterpreter *shared __attribute__((swift_name("shared")));
- (SharedDishInterpretationResult *)interpretDishTextRawInput:(NSString *)rawInput __attribute__((swift_name("interpretDishText(rawInput:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("NutrientBreakdown")))
@interface SharedNutrientBreakdown : SharedBase
- (instancetype)initWithCalories:(int32_t)calories proteinG:(float)proteinG carbsG:(float)carbsG fatG:(float)fatG __attribute__((swift_name("init(calories:proteinG:carbsG:fatG:)"))) __attribute__((objc_designated_initializer));
- (SharedNutrientBreakdown *)doCopyCalories:(int32_t)calories proteinG:(float)proteinG carbsG:(float)carbsG fatG:(float)fatG __attribute__((swift_name("doCopy(calories:proteinG:carbsG:fatG:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (SharedNutrientBreakdown *)plusOther:(SharedNutrientBreakdown *)other __attribute__((swift_name("plus(other:)")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) int32_t calories __attribute__((swift_name("calories")));
@property (readonly) float carbsG __attribute__((swift_name("carbsG")));
@property (readonly) float fatG __attribute__((swift_name("fatG")));
@property (readonly) float proteinG __attribute__((swift_name("proteinG")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PortionUnit")))
@interface SharedPortionUnit : SharedKotlinEnum<SharedPortionUnit *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) SharedPortionUnitCompanion *companion __attribute__((swift_name("companion")));
@property (class, readonly) SharedPortionUnit *piece __attribute__((swift_name("piece")));
@property (class, readonly) SharedPortionUnit *katori __attribute__((swift_name("katori")));
@property (class, readonly) SharedPortionUnit *cup __attribute__((swift_name("cup")));
@property (class, readonly) SharedPortionUnit *tablespoon __attribute__((swift_name("tablespoon")));
@property (class, readonly) SharedPortionUnit *gram __attribute__((swift_name("gram")));
+ (SharedKotlinArray<SharedPortionUnit *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<SharedPortionUnit *> *entries __attribute__((swift_name("entries")));
@property (readonly) float defaultGrams __attribute__((swift_name("defaultGrams")));
@property (readonly) NSString *displayName __attribute__((swift_name("displayName")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PortionUnit.Companion")))
@interface SharedPortionUnitCompanion : SharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SharedPortionUnitCompanion *shared __attribute__((swift_name("shared")));
- (SharedPortionUnit *)fromStringName:(NSString *)name __attribute__((swift_name("fromString(name:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PrepStyle")))
@interface SharedPrepStyle : SharedKotlinEnum<SharedPrepStyle *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) SharedPrepStyleCompanion *companion __attribute__((swift_name("companion")));
@property (class, readonly) SharedPrepStyle *homemade __attribute__((swift_name("homemade")));
@property (class, readonly) SharedPrepStyle *standard __attribute__((swift_name("standard")));
@property (class, readonly) SharedPrepStyle *restaurantRich __attribute__((swift_name("restaurantRich")));
+ (SharedKotlinArray<SharedPrepStyle *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<SharedPrepStyle *> *entries __attribute__((swift_name("entries")));
@property (readonly) float calorieMultiplier __attribute__((swift_name("calorieMultiplier")));
@property (readonly) NSString *displayName __attribute__((swift_name("displayName")));
@property (readonly) float fatMultiplier __attribute__((swift_name("fatMultiplier")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PrepStyle.Companion")))
@interface SharedPrepStyleCompanion : SharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SharedPrepStyleCompanion *shared __attribute__((swift_name("shared")));
- (SharedPrepStyle *)fromStringName:(NSString *)name __attribute__((swift_name("fromString(name:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("KotlinEnumCompanion")))
@interface SharedKotlinEnumCompanion : SharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SharedKotlinEnumCompanion *shared __attribute__((swift_name("shared")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("KotlinArray")))
@interface SharedKotlinArray<T> : SharedBase
+ (instancetype)arrayWithSize:(int32_t)size init:(T _Nullable (^)(SharedInt *))init __attribute__((swift_name("init(size:init:)")));
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (T _Nullable)getIndex:(int32_t)index __attribute__((swift_name("get(index:)")));
- (id<SharedKotlinIterator>)iterator __attribute__((swift_name("iterator()")));
- (void)setIndex:(int32_t)index value:(T _Nullable)value __attribute__((swift_name("set(index:value:)")));
@property (readonly) int32_t size __attribute__((swift_name("size")));
@end

__attribute__((swift_name("KotlinIterator")))
@protocol SharedKotlinIterator
@required
- (BOOL)hasNext __attribute__((swift_name("hasNext()")));
- (id _Nullable)next __attribute__((swift_name("next()")));
@end

#pragma pop_macro("_Nullable_result")
#pragma clang diagnostic pop
NS_ASSUME_NONNULL_END
