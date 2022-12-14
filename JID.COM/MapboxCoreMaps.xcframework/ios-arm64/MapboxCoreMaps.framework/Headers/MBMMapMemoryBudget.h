// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

@class MBMMapMemoryBudgetInMegabytes;
@class MBMMapMemoryBudgetInTiles;
// NOLINTNEXTLINE(modernize-use-using)
typedef NS_ENUM(NSInteger, MBMMapMemoryBudgetType)
{
    MBMMapMemoryBudgetTypeMapMemoryBudgetInMegabytes,
    MBMMapMemoryBudgetTypeMapMemoryBudgetInTiles
} NS_SWIFT_NAME(MapMemoryBudgetType);

NS_SWIFT_NAME(MapMemoryBudget)
__attribute__((visibility ("default")))
@interface MBMMapMemoryBudget : NSObject

- (nonnull instancetype)initWithValue:(nonnull id)value __attribute__((deprecated("Please use: '+from{TypeName}:' instead.")));

+ (nonnull instancetype)fromMapMemoryBudgetInMegabytes:(nonnull MBMMapMemoryBudgetInMegabytes *)value;
+ (nonnull instancetype)fromMapMemoryBudgetInTiles:(nonnull MBMMapMemoryBudgetInTiles *)value;

- (BOOL)isMapMemoryBudgetInMegabytes;
- (BOOL)isMapMemoryBudgetInTiles;

- (nonnull MBMMapMemoryBudgetInMegabytes *)getMapMemoryBudgetInMegabytes __attribute((ns_returns_retained));
- (nonnull MBMMapMemoryBudgetInTiles *)getMapMemoryBudgetInTiles __attribute((ns_returns_retained));

@property (nonatomic, nonnull) id value;

@property (nonatomic, readonly) MBMMapMemoryBudgetType type;

@end
