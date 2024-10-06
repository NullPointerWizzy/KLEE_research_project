; ModuleID = 'get_sign.bc'
source_filename = "get_sign.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [2 x i8] c"a\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @get_sign(i32 noundef %0) #0 !dbg !10 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  call void @llvm.dbg.declare(metadata i32* %3, metadata !15, metadata !DIExpression()), !dbg !16
  %4 = load i32, i32* %3, align 4, !dbg !17
  %5 = icmp eq i32 %4, 0, !dbg !19
  br i1 %5, label %6, label %7, !dbg !20

6:                                                ; preds = %1
  store i32 0, i32* %2, align 4, !dbg !21
  br label %12, !dbg !21

7:                                                ; preds = %1
  %8 = load i32, i32* %3, align 4, !dbg !22
  %9 = icmp slt i32 %8, 0, !dbg !24
  br i1 %9, label %10, label %11, !dbg !25

10:                                               ; preds = %7
  store i32 -1, i32* %2, align 4, !dbg !26
  br label %12, !dbg !26

11:                                               ; preds = %7
  store i32 1, i32* %2, align 4, !dbg !27
  br label %12, !dbg !27

12:                                               ; preds = %11, %10, %6
  %13 = load i32, i32* %2, align 4, !dbg !28
  ret i32 %13, !dbg !28
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !29 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !32, metadata !DIExpression()), !dbg !33
  %3 = bitcast i32* %2 to i8*, !dbg !34
  call void @klee_make_symbolic(i8* noundef %3, i64 noundef 4, i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0)), !dbg !35
  %4 = load i32, i32* %2, align 4, !dbg !36
  %5 = call i32 @get_sign(i32 noundef %4), !dbg !37
  ret i32 %5, !dbg !38
}

declare void @klee_make_symbolic(i8* noundef, i64 noundef, i8* noundef) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7, !8}
!llvm.ident = !{!9}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Debian clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "get_sign.c", directory: "/home/thomas/Documents/Cours/ter/get_sign", checksumkind: CSK_MD5, checksum: "ac9af9419e2db0df73c74d43874e0ee6")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 7, !"PIC Level", i32 2}
!6 = !{i32 7, !"PIE Level", i32 2}
!7 = !{i32 7, !"uwtable", i32 1}
!8 = !{i32 7, !"frame-pointer", i32 2}
!9 = !{!"Debian clang version 14.0.6"}
!10 = distinct !DISubprogram(name: "get_sign", scope: !1, file: !1, line: 3, type: !11, scopeLine: 3, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !14)
!11 = !DISubroutineType(types: !12)
!12 = !{!13, !13}
!13 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!14 = !{}
!15 = !DILocalVariable(name: "x", arg: 1, scope: !10, file: !1, line: 3, type: !13)
!16 = !DILocation(line: 3, column: 18, scope: !10)
!17 = !DILocation(line: 4, column: 7, scope: !18)
!18 = distinct !DILexicalBlock(scope: !10, file: !1, line: 4, column: 7)
!19 = !DILocation(line: 4, column: 9, scope: !18)
!20 = !DILocation(line: 4, column: 7, scope: !10)
!21 = !DILocation(line: 5, column: 5, scope: !18)
!22 = !DILocation(line: 7, column: 7, scope: !23)
!23 = distinct !DILexicalBlock(scope: !10, file: !1, line: 7, column: 7)
!24 = !DILocation(line: 7, column: 9, scope: !23)
!25 = !DILocation(line: 7, column: 7, scope: !10)
!26 = !DILocation(line: 8, column: 5, scope: !23)
!27 = !DILocation(line: 10, column: 5, scope: !23)
!28 = !DILocation(line: 11, column: 1, scope: !10)
!29 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 13, type: !30, scopeLine: 13, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !14)
!30 = !DISubroutineType(types: !31)
!31 = !{!13}
!32 = !DILocalVariable(name: "a", scope: !29, file: !1, line: 14, type: !13)
!33 = !DILocation(line: 14, column: 7, scope: !29)
!34 = !DILocation(line: 15, column: 22, scope: !29)
!35 = !DILocation(line: 15, column: 3, scope: !29)
!36 = !DILocation(line: 16, column: 19, scope: !29)
!37 = !DILocation(line: 16, column: 10, scope: !29)
!38 = !DILocation(line: 16, column: 3, scope: !29)
