; ModuleID = 'exemple.bc'
source_filename = "exemple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [2 x i8] c"y\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"yes\00", align 1
@.str.2 = private unnamed_addr constant [3 x i8] c"OK\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !10 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !15, metadata !DIExpression()), !dbg !16
  %4 = bitcast i32* %2 to i8*, !dbg !17
  call void @klee_make_symbolic(i8* noundef %4, i64 noundef 4, i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0)), !dbg !18
  call void @llvm.dbg.declare(metadata i32* %3, metadata !19, metadata !DIExpression()), !dbg !20
  %5 = load i32, i32* %2, align 4, !dbg !21
  %6 = mul nsw i32 %5, 2, !dbg !22
  store i32 %6, i32* %3, align 4, !dbg !20
  %7 = load i32, i32* %3, align 4, !dbg !23
  %8 = icmp slt i32 %7, 12, !dbg !25
  br i1 %8, label %9, label %17, !dbg !26

9:                                                ; preds = %0
  %10 = load i32, i32* %3, align 4, !dbg !27
  %11 = srem i32 %10, 2, !dbg !30
  %12 = icmp eq i32 %11, 0, !dbg !31
  br i1 %12, label %13, label %14, !dbg !32

13:                                               ; preds = %9
  store i32 8, i32* %3, align 4, !dbg !33
  br label %15, !dbg !35

14:                                               ; preds = %9
  store i32 6, i32* %3, align 4, !dbg !36
  br label %15

15:                                               ; preds = %14, %13
  %16 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0)), !dbg !38
  br label %19, !dbg !39

17:                                               ; preds = %0
  %18 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str.2, i64 0, i64 0)), !dbg !40
  br label %19

19:                                               ; preds = %17, %15
  %20 = load i32, i32* %1, align 4, !dbg !41
  ret i32 %20, !dbg !41
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @klee_make_symbolic(i8* noundef, i64 noundef, i8* noundef) #2

declare i32 @printf(i8* noundef, ...) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7, !8}
!llvm.ident = !{!9}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Debian clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "exemple.c", directory: "/home/thomas/Documents/Cours/ter/exemple", checksumkind: CSK_MD5, checksum: "57a2ab53003f278fd6a276bdb66800a2")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 7, !"PIC Level", i32 2}
!6 = !{i32 7, !"PIE Level", i32 2}
!7 = !{i32 7, !"uwtable", i32 1}
!8 = !{i32 7, !"frame-pointer", i32 2}
!9 = !{!"Debian clang version 14.0.6"}
!10 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 4, type: !11, scopeLine: 4, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !14)
!11 = !DISubroutineType(types: !12)
!12 = !{!13}
!13 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!14 = !{}
!15 = !DILocalVariable(name: "y", scope: !10, file: !1, line: 5, type: !13)
!16 = !DILocation(line: 5, column: 9, scope: !10)
!17 = !DILocation(line: 6, column: 22, scope: !10)
!18 = !DILocation(line: 6, column: 3, scope: !10)
!19 = !DILocalVariable(name: "z", scope: !10, file: !1, line: 7, type: !13)
!20 = !DILocation(line: 7, column: 9, scope: !10)
!21 = !DILocation(line: 7, column: 13, scope: !10)
!22 = !DILocation(line: 7, column: 15, scope: !10)
!23 = !DILocation(line: 8, column: 9, scope: !24)
!24 = distinct !DILexicalBlock(scope: !10, file: !1, line: 8, column: 9)
!25 = !DILocation(line: 8, column: 11, scope: !24)
!26 = !DILocation(line: 8, column: 9, scope: !10)
!27 = !DILocation(line: 9, column: 10, scope: !28)
!28 = distinct !DILexicalBlock(scope: !29, file: !1, line: 9, column: 10)
!29 = distinct !DILexicalBlock(scope: !24, file: !1, line: 8, column: 16)
!30 = !DILocation(line: 9, column: 11, scope: !28)
!31 = !DILocation(line: 9, column: 13, scope: !28)
!32 = !DILocation(line: 9, column: 10, scope: !29)
!33 = !DILocation(line: 10, column: 10, scope: !34)
!34 = distinct !DILexicalBlock(scope: !28, file: !1, line: 9, column: 17)
!35 = !DILocation(line: 11, column: 7, scope: !34)
!36 = !DILocation(line: 12, column: 10, scope: !37)
!37 = distinct !DILexicalBlock(scope: !28, file: !1, line: 11, column: 12)
!38 = !DILocation(line: 14, column: 7, scope: !29)
!39 = !DILocation(line: 15, column: 5, scope: !29)
!40 = !DILocation(line: 17, column: 7, scope: !24)
!41 = !DILocation(line: 18, column: 1, scope: !10)
