; ModuleID = 'password.bc'
source_filename = "password.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [17 x i8] c"Password found!\0A\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @check_password(i8* noundef %0) #0 !dbg !10 {
  %2 = alloca i32, align 4
  %3 = alloca i8*, align 8
  store i8* %0, i8** %3, align 8
  call void @llvm.dbg.declare(metadata i8** %3, metadata !17, metadata !DIExpression()), !dbg !18
  %4 = load i8*, i8** %3, align 8, !dbg !19
  %5 = getelementptr inbounds i8, i8* %4, i64 0, !dbg !19
  %6 = load i8, i8* %5, align 1, !dbg !19
  %7 = sext i8 %6 to i32, !dbg !19
  %8 = icmp eq i32 %7, 104, !dbg !21
  br i1 %8, label %9, label %34, !dbg !22

9:                                                ; preds = %1
  %10 = load i8*, i8** %3, align 8, !dbg !23
  %11 = getelementptr inbounds i8, i8* %10, i64 1, !dbg !23
  %12 = load i8, i8* %11, align 1, !dbg !23
  %13 = sext i8 %12 to i32, !dbg !23
  %14 = icmp eq i32 %13, 101, !dbg !24
  br i1 %14, label %15, label %34, !dbg !25

15:                                               ; preds = %9
  %16 = load i8*, i8** %3, align 8, !dbg !26
  %17 = getelementptr inbounds i8, i8* %16, i64 2, !dbg !26
  %18 = load i8, i8* %17, align 1, !dbg !26
  %19 = sext i8 %18 to i32, !dbg !26
  %20 = icmp eq i32 %19, 108, !dbg !27
  br i1 %20, label %21, label %34, !dbg !28

21:                                               ; preds = %15
  %22 = load i8*, i8** %3, align 8, !dbg !29
  %23 = getelementptr inbounds i8, i8* %22, i64 3, !dbg !29
  %24 = load i8, i8* %23, align 1, !dbg !29
  %25 = sext i8 %24 to i32, !dbg !29
  %26 = icmp eq i32 %25, 108, !dbg !30
  br i1 %26, label %27, label %34, !dbg !31

27:                                               ; preds = %21
  %28 = load i8*, i8** %3, align 8, !dbg !32
  %29 = getelementptr inbounds i8, i8* %28, i64 4, !dbg !32
  %30 = load i8, i8* %29, align 1, !dbg !32
  %31 = sext i8 %30 to i32, !dbg !32
  %32 = icmp eq i32 %31, 111, !dbg !33
  br i1 %32, label %33, label %34, !dbg !34

33:                                               ; preds = %27
  store i32 1, i32* %2, align 4, !dbg !35
  br label %35, !dbg !35

34:                                               ; preds = %27, %21, %15, %9, %1
  store i32 0, i32* %2, align 4, !dbg !36
  br label %35, !dbg !36

35:                                               ; preds = %34, %33
  %36 = load i32, i32* %2, align 4, !dbg !37
  ret i32 %36, !dbg !37
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main(i32 noundef %0, i8** noundef %1) #0 !dbg !38 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !42, metadata !DIExpression()), !dbg !43
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !44, metadata !DIExpression()), !dbg !45
  %6 = load i32, i32* %4, align 4, !dbg !46
  %7 = icmp slt i32 %6, 2, !dbg !48
  br i1 %7, label %8, label %9, !dbg !49

8:                                                ; preds = %2
  store i32 1, i32* %3, align 4, !dbg !50
  br label %18, !dbg !50

9:                                                ; preds = %2
  %10 = load i8**, i8*** %5, align 8, !dbg !51
  %11 = getelementptr inbounds i8*, i8** %10, i64 1, !dbg !51
  %12 = load i8*, i8** %11, align 8, !dbg !51
  %13 = call i32 @check_password(i8* noundef %12), !dbg !53
  %14 = icmp ne i32 %13, 0, !dbg !53
  br i1 %14, label %15, label %17, !dbg !54

15:                                               ; preds = %9
  %16 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str, i64 0, i64 0)), !dbg !55
  store i32 0, i32* %3, align 4, !dbg !57
  br label %18, !dbg !57

17:                                               ; preds = %9
  store i32 1, i32* %3, align 4, !dbg !58
  br label %18, !dbg !58

18:                                               ; preds = %17, %15, %8
  %19 = load i32, i32* %3, align 4, !dbg !59
  ret i32 %19, !dbg !59
}

declare i32 @printf(i8* noundef, ...) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7, !8}
!llvm.ident = !{!9}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Debian clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "password.c", directory: "/home/thomas/Documents/Cours/ter/test_sym", checksumkind: CSK_MD5, checksum: "7fc7571babef83dcfef713ce19f46d5d")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 7, !"PIC Level", i32 2}
!6 = !{i32 7, !"PIE Level", i32 2}
!7 = !{i32 7, !"uwtable", i32 1}
!8 = !{i32 7, !"frame-pointer", i32 2}
!9 = !{!"Debian clang version 14.0.6"}
!10 = distinct !DISubprogram(name: "check_password", scope: !1, file: !1, line: 3, type: !11, scopeLine: 3, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !16)
!11 = !DISubroutineType(types: !12)
!12 = !{!13, !14}
!13 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!15 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!16 = !{}
!17 = !DILocalVariable(name: "buf", arg: 1, scope: !10, file: !1, line: 3, type: !14)
!18 = !DILocation(line: 3, column: 26, scope: !10)
!19 = !DILocation(line: 4, column: 7, scope: !20)
!20 = distinct !DILexicalBlock(scope: !10, file: !1, line: 4, column: 7)
!21 = !DILocation(line: 4, column: 14, scope: !20)
!22 = !DILocation(line: 4, column: 21, scope: !20)
!23 = !DILocation(line: 4, column: 24, scope: !20)
!24 = !DILocation(line: 4, column: 31, scope: !20)
!25 = !DILocation(line: 4, column: 38, scope: !20)
!26 = !DILocation(line: 5, column: 7, scope: !20)
!27 = !DILocation(line: 5, column: 14, scope: !20)
!28 = !DILocation(line: 5, column: 21, scope: !20)
!29 = !DILocation(line: 5, column: 24, scope: !20)
!30 = !DILocation(line: 5, column: 31, scope: !20)
!31 = !DILocation(line: 5, column: 38, scope: !20)
!32 = !DILocation(line: 6, column: 7, scope: !20)
!33 = !DILocation(line: 6, column: 14, scope: !20)
!34 = !DILocation(line: 4, column: 7, scope: !10)
!35 = !DILocation(line: 7, column: 5, scope: !20)
!36 = !DILocation(line: 8, column: 3, scope: !10)
!37 = !DILocation(line: 9, column: 1, scope: !10)
!38 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 11, type: !39, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !16)
!39 = !DISubroutineType(types: !40)
!40 = !{!13, !13, !41}
!41 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!42 = !DILocalVariable(name: "argc", arg: 1, scope: !38, file: !1, line: 11, type: !13)
!43 = !DILocation(line: 11, column: 14, scope: !38)
!44 = !DILocalVariable(name: "argv", arg: 2, scope: !38, file: !1, line: 11, type: !41)
!45 = !DILocation(line: 11, column: 27, scope: !38)
!46 = !DILocation(line: 12, column: 7, scope: !47)
!47 = distinct !DILexicalBlock(scope: !38, file: !1, line: 12, column: 7)
!48 = !DILocation(line: 12, column: 12, scope: !47)
!49 = !DILocation(line: 12, column: 7, scope: !38)
!50 = !DILocation(line: 13, column: 6, scope: !47)
!51 = !DILocation(line: 15, column: 22, scope: !52)
!52 = distinct !DILexicalBlock(scope: !38, file: !1, line: 15, column: 7)
!53 = !DILocation(line: 15, column: 7, scope: !52)
!54 = !DILocation(line: 15, column: 7, scope: !38)
!55 = !DILocation(line: 16, column: 5, scope: !56)
!56 = distinct !DILexicalBlock(scope: !52, file: !1, line: 15, column: 32)
!57 = !DILocation(line: 17, column: 5, scope: !56)
!58 = !DILocation(line: 20, column: 3, scope: !38)
!59 = !DILocation(line: 21, column: 1, scope: !38)
