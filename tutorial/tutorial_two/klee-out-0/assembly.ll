; ModuleID = 'Regexp.bc'
source_filename = "Regexp.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [3 x i8] c"re\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"hello\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @match(i8* noundef %0, i8* noundef %1) #0 !dbg !10 {
  %3 = alloca i32, align 4
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  store i8* %0, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !17, metadata !DIExpression()), !dbg !18
  store i8* %1, i8** %5, align 8
  call void @llvm.dbg.declare(metadata i8** %5, metadata !19, metadata !DIExpression()), !dbg !20
  %6 = load i8*, i8** %4, align 8, !dbg !21
  %7 = getelementptr inbounds i8, i8* %6, i64 0, !dbg !21
  %8 = load i8, i8* %7, align 1, !dbg !21
  %9 = sext i8 %8 to i32, !dbg !21
  %10 = icmp eq i32 %9, 94, !dbg !23
  br i1 %10, label %11, label %16, !dbg !24

11:                                               ; preds = %2
  %12 = load i8*, i8** %4, align 8, !dbg !25
  %13 = getelementptr inbounds i8, i8* %12, i64 1, !dbg !26
  %14 = load i8*, i8** %5, align 8, !dbg !27
  %15 = call i32 @matchhere(i8* noundef %13, i8* noundef %14), !dbg !28
  store i32 %15, i32* %3, align 4, !dbg !29
  br label %29, !dbg !29

16:                                               ; preds = %2, %22
  %17 = load i8*, i8** %4, align 8, !dbg !30
  %18 = load i8*, i8** %5, align 8, !dbg !33
  %19 = call i32 @matchhere(i8* noundef %17, i8* noundef %18), !dbg !34
  %20 = icmp ne i32 %19, 0, !dbg !34
  br i1 %20, label %21, label %22, !dbg !35

21:                                               ; preds = %16
  store i32 1, i32* %3, align 4, !dbg !36
  br label %29, !dbg !36

22:                                               ; preds = %16
  %23 = load i8*, i8** %5, align 8, !dbg !37
  %24 = getelementptr inbounds i8, i8* %23, i32 1, !dbg !37
  store i8* %24, i8** %5, align 8, !dbg !37
  %25 = load i8, i8* %23, align 1, !dbg !38
  %26 = sext i8 %25 to i32, !dbg !38
  %27 = icmp ne i32 %26, 0, !dbg !39
  br i1 %27, label %16, label %28, !dbg !40, !llvm.loop !41

28:                                               ; preds = %22
  store i32 0, i32* %3, align 4, !dbg !45
  br label %29, !dbg !45

29:                                               ; preds = %28, %21, %11
  %30 = load i32, i32* %3, align 4, !dbg !46
  ret i32 %30, !dbg !46
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal i32 @matchhere(i8* noundef %0, i8* noundef %1) #0 !dbg !47 {
  %3 = alloca i32, align 4
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  store i8* %0, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !48, metadata !DIExpression()), !dbg !49
  store i8* %1, i8** %5, align 8
  call void @llvm.dbg.declare(metadata i8** %5, metadata !50, metadata !DIExpression()), !dbg !51
  %6 = load i8*, i8** %4, align 8, !dbg !52
  %7 = getelementptr inbounds i8, i8* %6, i64 0, !dbg !52
  %8 = load i8, i8* %7, align 1, !dbg !52
  %9 = sext i8 %8 to i32, !dbg !52
  %10 = icmp eq i32 %9, 0, !dbg !54
  br i1 %10, label %11, label %12, !dbg !55

11:                                               ; preds = %2
  store i32 0, i32* %3, align 4, !dbg !56
  br label %72, !dbg !56

12:                                               ; preds = %2
  %13 = load i8*, i8** %4, align 8, !dbg !57
  %14 = getelementptr inbounds i8, i8* %13, i64 1, !dbg !57
  %15 = load i8, i8* %14, align 1, !dbg !57
  %16 = sext i8 %15 to i32, !dbg !57
  %17 = icmp eq i32 %16, 42, !dbg !59
  br i1 %17, label %18, label %27, !dbg !60

18:                                               ; preds = %12
  %19 = load i8*, i8** %4, align 8, !dbg !61
  %20 = getelementptr inbounds i8, i8* %19, i64 0, !dbg !61
  %21 = load i8, i8* %20, align 1, !dbg !61
  %22 = sext i8 %21 to i32, !dbg !61
  %23 = load i8*, i8** %4, align 8, !dbg !62
  %24 = getelementptr inbounds i8, i8* %23, i64 2, !dbg !63
  %25 = load i8*, i8** %5, align 8, !dbg !64
  %26 = call i32 @matchstar(i32 noundef %22, i8* noundef %24, i8* noundef %25), !dbg !65
  store i32 %26, i32* %3, align 4, !dbg !66
  br label %72, !dbg !66

27:                                               ; preds = %12
  %28 = load i8*, i8** %4, align 8, !dbg !67
  %29 = getelementptr inbounds i8, i8* %28, i64 0, !dbg !67
  %30 = load i8, i8* %29, align 1, !dbg !67
  %31 = sext i8 %30 to i32, !dbg !67
  %32 = icmp eq i32 %31, 36, !dbg !69
  br i1 %32, label %33, label %45, !dbg !70

33:                                               ; preds = %27
  %34 = load i8*, i8** %4, align 8, !dbg !71
  %35 = getelementptr inbounds i8, i8* %34, i64 1, !dbg !71
  %36 = load i8, i8* %35, align 1, !dbg !71
  %37 = sext i8 %36 to i32, !dbg !71
  %38 = icmp eq i32 %37, 0, !dbg !72
  br i1 %38, label %39, label %45, !dbg !73

39:                                               ; preds = %33
  %40 = load i8*, i8** %5, align 8, !dbg !74
  %41 = load i8, i8* %40, align 1, !dbg !75
  %42 = sext i8 %41 to i32, !dbg !75
  %43 = icmp eq i32 %42, 0, !dbg !76
  %44 = zext i1 %43 to i32, !dbg !76
  store i32 %44, i32* %3, align 4, !dbg !77
  br label %72, !dbg !77

45:                                               ; preds = %33, %27
  %46 = load i8*, i8** %5, align 8, !dbg !78
  %47 = load i8, i8* %46, align 1, !dbg !80
  %48 = sext i8 %47 to i32, !dbg !80
  %49 = icmp ne i32 %48, 0, !dbg !81
  br i1 %49, label %50, label %71, !dbg !82

50:                                               ; preds = %45
  %51 = load i8*, i8** %4, align 8, !dbg !83
  %52 = getelementptr inbounds i8, i8* %51, i64 0, !dbg !83
  %53 = load i8, i8* %52, align 1, !dbg !83
  %54 = sext i8 %53 to i32, !dbg !83
  %55 = icmp eq i32 %54, 46, !dbg !84
  br i1 %55, label %65, label %56, !dbg !85

56:                                               ; preds = %50
  %57 = load i8*, i8** %4, align 8, !dbg !86
  %58 = getelementptr inbounds i8, i8* %57, i64 0, !dbg !86
  %59 = load i8, i8* %58, align 1, !dbg !86
  %60 = sext i8 %59 to i32, !dbg !86
  %61 = load i8*, i8** %5, align 8, !dbg !87
  %62 = load i8, i8* %61, align 1, !dbg !88
  %63 = sext i8 %62 to i32, !dbg !88
  %64 = icmp eq i32 %60, %63, !dbg !89
  br i1 %64, label %65, label %71, !dbg !90

65:                                               ; preds = %56, %50
  %66 = load i8*, i8** %4, align 8, !dbg !91
  %67 = getelementptr inbounds i8, i8* %66, i64 1, !dbg !92
  %68 = load i8*, i8** %5, align 8, !dbg !93
  %69 = getelementptr inbounds i8, i8* %68, i64 1, !dbg !94
  %70 = call i32 @matchhere(i8* noundef %67, i8* noundef %69), !dbg !95
  store i32 %70, i32* %3, align 4, !dbg !96
  br label %72, !dbg !96

71:                                               ; preds = %56, %45
  store i32 0, i32* %3, align 4, !dbg !97
  br label %72, !dbg !97

72:                                               ; preds = %71, %65, %39, %18, %11
  %73 = load i32, i32* %3, align 4, !dbg !98
  ret i32 %73, !dbg !98
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !99 {
  %1 = alloca i32, align 4
  %2 = alloca [7 x i8], align 1
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [7 x i8]* %2, metadata !102, metadata !DIExpression()), !dbg !106
  %3 = getelementptr inbounds [7 x i8], [7 x i8]* %2, i64 0, i64 0, !dbg !107
  call void @klee_make_symbolic(i8* noundef %3, i64 noundef 7, i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str, i64 0, i64 0)), !dbg !108
  %4 = getelementptr inbounds [7 x i8], [7 x i8]* %2, i64 0, i64 0, !dbg !109
  %5 = call i32 @match(i8* noundef %4, i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i64 0, i64 0)), !dbg !110
  ret i32 0, !dbg !111
}

declare void @klee_make_symbolic(i8* noundef, i64 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal i32 @matchstar(i32 noundef %0, i8* noundef %1, i8* noundef %2) #0 !dbg !112 {
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i8*, align 8
  %7 = alloca i8*, align 8
  store i32 %0, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !115, metadata !DIExpression()), !dbg !116
  store i8* %1, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !117, metadata !DIExpression()), !dbg !118
  store i8* %2, i8** %7, align 8
  call void @llvm.dbg.declare(metadata i8** %7, metadata !119, metadata !DIExpression()), !dbg !120
  br label %8, !dbg !121

8:                                                ; preds = %19, %3
  %9 = load i8*, i8** %6, align 8, !dbg !122
  %10 = load i8*, i8** %7, align 8, !dbg !125
  %11 = call i32 @matchhere(i8* noundef %9, i8* noundef %10), !dbg !126
  %12 = icmp ne i32 %11, 0, !dbg !126
  br i1 %12, label %13, label %14, !dbg !127

13:                                               ; preds = %8
  store i32 1, i32* %4, align 4, !dbg !128
  br label %29, !dbg !128

14:                                               ; preds = %8
  %15 = load i8*, i8** %7, align 8, !dbg !129
  %16 = load i8, i8* %15, align 1, !dbg !130
  %17 = sext i8 %16 to i32, !dbg !130
  %18 = icmp ne i32 %17, 0, !dbg !131
  br i1 %18, label %19, label %.critedge, !dbg !132

19:                                               ; preds = %14
  %20 = load i8*, i8** %7, align 8, !dbg !133
  %21 = getelementptr inbounds i8, i8* %20, i32 1, !dbg !133
  store i8* %21, i8** %7, align 8, !dbg !133
  %22 = load i8, i8* %20, align 1, !dbg !134
  %23 = sext i8 %22 to i32, !dbg !134
  %24 = load i32, i32* %5, align 4, !dbg !135
  %25 = icmp eq i32 %23, %24, !dbg !136
  %26 = load i32, i32* %5, align 4, !dbg !137
  %27 = icmp eq i32 %26, 46, !dbg !137
  %28 = select i1 %25, i1 true, i1 %27, !dbg !137
  br i1 %28, label %8, label %.critedge, !dbg !138, !llvm.loop !139

.critedge:                                        ; preds = %14, %19
  store i32 0, i32* %4, align 4, !dbg !141
  br label %29, !dbg !141

29:                                               ; preds = %.critedge, %13
  %30 = load i32, i32* %4, align 4, !dbg !142
  ret i32 %30, !dbg !142
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7, !8}
!llvm.ident = !{!9}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Debian clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "Regexp.c", directory: "/home/thomas/Documents/Cours/ter/tutorial_two", checksumkind: CSK_MD5, checksum: "6fda757c27d243597ef24becaf8b9200")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 7, !"PIC Level", i32 2}
!6 = !{i32 7, !"PIE Level", i32 2}
!7 = !{i32 7, !"uwtable", i32 1}
!8 = !{i32 7, !"frame-pointer", i32 2}
!9 = !{!"Debian clang version 14.0.6"}
!10 = distinct !DISubprogram(name: "match", scope: !1, file: !1, line: 34, type: !11, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !16)
!11 = !DISubroutineType(types: !12)
!12 = !{!13, !14, !14}
!13 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!15 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!16 = !{}
!17 = !DILocalVariable(name: "re", arg: 1, scope: !10, file: !1, line: 34, type: !14)
!18 = !DILocation(line: 34, column: 17, scope: !10)
!19 = !DILocalVariable(name: "text", arg: 2, scope: !10, file: !1, line: 34, type: !14)
!20 = !DILocation(line: 34, column: 27, scope: !10)
!21 = !DILocation(line: 35, column: 7, scope: !22)
!22 = distinct !DILexicalBlock(scope: !10, file: !1, line: 35, column: 7)
!23 = !DILocation(line: 35, column: 13, scope: !22)
!24 = !DILocation(line: 35, column: 7, scope: !10)
!25 = !DILocation(line: 36, column: 22, scope: !22)
!26 = !DILocation(line: 36, column: 24, scope: !22)
!27 = !DILocation(line: 36, column: 28, scope: !22)
!28 = !DILocation(line: 36, column: 12, scope: !22)
!29 = !DILocation(line: 36, column: 5, scope: !22)
!30 = !DILocation(line: 38, column: 19, scope: !31)
!31 = distinct !DILexicalBlock(scope: !32, file: !1, line: 38, column: 9)
!32 = distinct !DILexicalBlock(scope: !10, file: !1, line: 37, column: 6)
!33 = !DILocation(line: 38, column: 23, scope: !31)
!34 = !DILocation(line: 38, column: 9, scope: !31)
!35 = !DILocation(line: 38, column: 9, scope: !32)
!36 = !DILocation(line: 39, column: 7, scope: !31)
!37 = !DILocation(line: 40, column: 17, scope: !10)
!38 = !DILocation(line: 40, column: 12, scope: !10)
!39 = !DILocation(line: 40, column: 20, scope: !10)
!40 = !DILocation(line: 40, column: 3, scope: !32)
!41 = distinct !{!41, !42, !43, !44}
!42 = !DILocation(line: 37, column: 3, scope: !10)
!43 = !DILocation(line: 40, column: 27, scope: !10)
!44 = !{!"llvm.loop.mustprogress"}
!45 = !DILocation(line: 41, column: 3, scope: !10)
!46 = !DILocation(line: 42, column: 1, scope: !10)
!47 = distinct !DISubprogram(name: "matchhere", scope: !1, file: !1, line: 22, type: !11, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !16)
!48 = !DILocalVariable(name: "re", arg: 1, scope: !47, file: !1, line: 22, type: !14)
!49 = !DILocation(line: 22, column: 28, scope: !47)
!50 = !DILocalVariable(name: "text", arg: 2, scope: !47, file: !1, line: 22, type: !14)
!51 = !DILocation(line: 22, column: 38, scope: !47)
!52 = !DILocation(line: 23, column: 7, scope: !53)
!53 = distinct !DILexicalBlock(scope: !47, file: !1, line: 23, column: 7)
!54 = !DILocation(line: 23, column: 13, scope: !53)
!55 = !DILocation(line: 23, column: 7, scope: !47)
!56 = !DILocation(line: 24, column: 6, scope: !53)
!57 = !DILocation(line: 25, column: 7, scope: !58)
!58 = distinct !DILexicalBlock(scope: !47, file: !1, line: 25, column: 7)
!59 = !DILocation(line: 25, column: 13, scope: !58)
!60 = !DILocation(line: 25, column: 7, scope: !47)
!61 = !DILocation(line: 26, column: 22, scope: !58)
!62 = !DILocation(line: 26, column: 29, scope: !58)
!63 = !DILocation(line: 26, column: 31, scope: !58)
!64 = !DILocation(line: 26, column: 35, scope: !58)
!65 = !DILocation(line: 26, column: 12, scope: !58)
!66 = !DILocation(line: 26, column: 5, scope: !58)
!67 = !DILocation(line: 27, column: 7, scope: !68)
!68 = distinct !DILexicalBlock(scope: !47, file: !1, line: 27, column: 7)
!69 = !DILocation(line: 27, column: 13, scope: !68)
!70 = !DILocation(line: 27, column: 20, scope: !68)
!71 = !DILocation(line: 27, column: 23, scope: !68)
!72 = !DILocation(line: 27, column: 28, scope: !68)
!73 = !DILocation(line: 27, column: 7, scope: !47)
!74 = !DILocation(line: 28, column: 13, scope: !68)
!75 = !DILocation(line: 28, column: 12, scope: !68)
!76 = !DILocation(line: 28, column: 18, scope: !68)
!77 = !DILocation(line: 28, column: 5, scope: !68)
!78 = !DILocation(line: 29, column: 8, scope: !79)
!79 = distinct !DILexicalBlock(scope: !47, file: !1, line: 29, column: 7)
!80 = !DILocation(line: 29, column: 7, scope: !79)
!81 = !DILocation(line: 29, column: 12, scope: !79)
!82 = !DILocation(line: 29, column: 19, scope: !79)
!83 = !DILocation(line: 29, column: 23, scope: !79)
!84 = !DILocation(line: 29, column: 28, scope: !79)
!85 = !DILocation(line: 29, column: 34, scope: !79)
!86 = !DILocation(line: 29, column: 37, scope: !79)
!87 = !DILocation(line: 29, column: 45, scope: !79)
!88 = !DILocation(line: 29, column: 44, scope: !79)
!89 = !DILocation(line: 29, column: 42, scope: !79)
!90 = !DILocation(line: 29, column: 7, scope: !47)
!91 = !DILocation(line: 30, column: 22, scope: !79)
!92 = !DILocation(line: 30, column: 24, scope: !79)
!93 = !DILocation(line: 30, column: 28, scope: !79)
!94 = !DILocation(line: 30, column: 32, scope: !79)
!95 = !DILocation(line: 30, column: 12, scope: !79)
!96 = !DILocation(line: 30, column: 5, scope: !79)
!97 = !DILocation(line: 31, column: 3, scope: !47)
!98 = !DILocation(line: 32, column: 1, scope: !47)
!99 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 51, type: !100, scopeLine: 51, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !16)
!100 = !DISubroutineType(types: !101)
!101 = !{!13}
!102 = !DILocalVariable(name: "re", scope: !99, file: !1, line: 53, type: !103)
!103 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 56, elements: !104)
!104 = !{!105}
!105 = !DISubrange(count: 7)
!106 = !DILocation(line: 53, column: 8, scope: !99)
!107 = !DILocation(line: 56, column: 22, scope: !99)
!108 = !DILocation(line: 56, column: 3, scope: !99)
!109 = !DILocation(line: 59, column: 9, scope: !99)
!110 = !DILocation(line: 59, column: 3, scope: !99)
!111 = !DILocation(line: 61, column: 3, scope: !99)
!112 = distinct !DISubprogram(name: "matchstar", scope: !1, file: !1, line: 14, type: !113, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !16)
!113 = !DISubroutineType(types: !114)
!114 = !{!13, !13, !14, !14}
!115 = !DILocalVariable(name: "c", arg: 1, scope: !112, file: !1, line: 14, type: !13)
!116 = !DILocation(line: 14, column: 26, scope: !112)
!117 = !DILocalVariable(name: "re", arg: 2, scope: !112, file: !1, line: 14, type: !14)
!118 = !DILocation(line: 14, column: 35, scope: !112)
!119 = !DILocalVariable(name: "text", arg: 3, scope: !112, file: !1, line: 14, type: !14)
!120 = !DILocation(line: 14, column: 45, scope: !112)
!121 = !DILocation(line: 15, column: 3, scope: !112)
!122 = !DILocation(line: 16, column: 19, scope: !123)
!123 = distinct !DILexicalBlock(scope: !124, file: !1, line: 16, column: 9)
!124 = distinct !DILexicalBlock(scope: !112, file: !1, line: 15, column: 6)
!125 = !DILocation(line: 16, column: 23, scope: !123)
!126 = !DILocation(line: 16, column: 9, scope: !123)
!127 = !DILocation(line: 16, column: 9, scope: !124)
!128 = !DILocation(line: 17, column: 7, scope: !123)
!129 = !DILocation(line: 18, column: 13, scope: !112)
!130 = !DILocation(line: 18, column: 12, scope: !112)
!131 = !DILocation(line: 18, column: 18, scope: !112)
!132 = !DILocation(line: 18, column: 26, scope: !112)
!133 = !DILocation(line: 18, column: 35, scope: !112)
!134 = !DILocation(line: 18, column: 30, scope: !112)
!135 = !DILocation(line: 18, column: 41, scope: !112)
!136 = !DILocation(line: 18, column: 38, scope: !112)
!137 = !DILocation(line: 18, column: 43, scope: !112)
!138 = !DILocation(line: 18, column: 3, scope: !124)
!139 = distinct !{!139, !121, !140, !44}
!140 = !DILocation(line: 18, column: 54, scope: !112)
!141 = !DILocation(line: 19, column: 3, scope: !112)
!142 = !DILocation(line: 20, column: 1, scope: !112)
