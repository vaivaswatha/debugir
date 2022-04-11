; ModuleID = 'hello.ll'
source_filename = "hello.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.S = type { float, i8 }

@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@.str.1 = private unnamed_addr constant [8 x i8] c"%f, %c\0A\00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@__const.main.s = private unnamed_addr constant %struct.S { float 1.000000e+00, i8 97 }, align 4
@.str.3 = private unnamed_addr constant [13 x i8] c"Hello World\0A\00", align 1
@__const.main.s.4 = private unnamed_addr constant %struct.S { float 0x3FF3333340000000, i8 98 }, align 4
@.str.5 = private unnamed_addr constant [10 x i8] c"No hello\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo(i32 %arg, i64 %arg1) #0 !dbg !6 {
bb:
  %tmp = alloca %struct.S, align 4, !dbg !12
  %tmp2 = alloca i32, align 4, !dbg !14
  %tmp3 = alloca i32, align 4, !dbg !15
  %tmp4 = bitcast %struct.S* %tmp to i64*, !dbg !16
  store i64 %arg1, i64* %tmp4, align 4, !dbg !17
  store i32 %arg, i32* %tmp2, align 4, !dbg !18
  %tmp5 = load i32, i32* %tmp2, align 4, !dbg !19
  %tmp6 = add nsw i32 %tmp5, 1, !dbg !20
  store i32 %tmp6, i32* %tmp3, align 4, !dbg !21
  %tmp7 = load i32, i32* %tmp3, align 4, !dbg !22
  %tmp8 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 %tmp7), !dbg !23
  %tmp9 = getelementptr inbounds %struct.S, %struct.S* %tmp, i32 0, i32 0, !dbg !24
  %tmp10 = load float, float* %tmp9, align 4, !dbg !25
  %tmp11 = fpext float %tmp10 to double, !dbg !26
  %tmp12 = getelementptr inbounds %struct.S, %struct.S* %tmp, i32 0, i32 1, !dbg !27
  %tmp13 = load i8, i8* %tmp12, align 4, !dbg !28
  %tmp14 = sext i8 %tmp13 to i32, !dbg !29
  %tmp15 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.1, i64 0, i64 0), double %tmp11, i32 %tmp14), !dbg !30
  call void @llvm.dbg.declare(metadata %struct.S* %tmp, metadata !31, metadata !DIExpression()), !dbg !12
  call void @llvm.dbg.declare(metadata i32* %tmp2, metadata !39, metadata !DIExpression()), !dbg !14
  call void @llvm.dbg.declare(metadata i32* %tmp3, metadata !40, metadata !DIExpression()), !dbg !15
  call void @llvm.dbg.declare(metadata i64* %tmp4, metadata !41, metadata !DIExpression()), !dbg !16
  call void @llvm.dbg.declare(metadata i32 %tmp5, metadata !42, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata i32 %tmp6, metadata !43, metadata !DIExpression()), !dbg !20
  call void @llvm.dbg.declare(metadata i32 %tmp7, metadata !44, metadata !DIExpression()), !dbg !22
  call void @llvm.dbg.declare(metadata i32 %tmp8, metadata !45, metadata !DIExpression()), !dbg !23
  call void @llvm.dbg.declare(metadata float* %tmp9, metadata !46, metadata !DIExpression()), !dbg !24
  call void @llvm.dbg.declare(metadata float %tmp10, metadata !47, metadata !DIExpression()), !dbg !25
  call void @llvm.dbg.declare(metadata double %tmp11, metadata !48, metadata !DIExpression()), !dbg !26
  call void @llvm.dbg.declare(metadata i8* %tmp12, metadata !50, metadata !DIExpression()), !dbg !27
  call void @llvm.dbg.declare(metadata i8 %tmp13, metadata !51, metadata !DIExpression()), !dbg !28
  call void @llvm.dbg.declare(metadata i32 %tmp14, metadata !52, metadata !DIExpression()), !dbg !29
  call void @llvm.dbg.declare(metadata i32 %tmp15, metadata !53, metadata !DIExpression()), !dbg !30
  ret void, !dbg !54
}

declare dso_local i32 @printf(i8*, ...) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %arg, i8** %arg1) #0 !dbg !55 {
bb:
  %tmp = alloca i32, align 4, !dbg !58
  %tmp2 = alloca i32, align 4, !dbg !60
  %tmp3 = alloca i8**, align 8, !dbg !61
  %tmp4 = alloca %struct.S, align 4, !dbg !62
  %tmp5 = alloca %struct.S, align 4, !dbg !63
  store i32 0, i32* %tmp, align 4, !dbg !64
  store i32 %arg, i32* %tmp2, align 4, !dbg !65
  store i8** %arg1, i8*** %tmp3, align 8, !dbg !66
  %tmp6 = load i8**, i8*** %tmp3, align 8, !dbg !67
  %tmp7 = getelementptr inbounds i8*, i8** %tmp6, i64 0, !dbg !68
  %tmp8 = load i8*, i8** %tmp7, align 8, !dbg !69
  %tmp9 = call i32 @strcmp(i8* %tmp8, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.2, i64 0, i64 0)) #5, !dbg !70
  %tmp10 = icmp ne i32 %tmp9, 0, !dbg !71
  call void @llvm.dbg.declare(metadata i32* %tmp, metadata !72, metadata !DIExpression()), !dbg !58
  call void @llvm.dbg.declare(metadata i32* %tmp2, metadata !73, metadata !DIExpression()), !dbg !60
  call void @llvm.dbg.declare(metadata i8*** %tmp3, metadata !74, metadata !DIExpression()), !dbg !61
  call void @llvm.dbg.declare(metadata %struct.S* %tmp4, metadata !75, metadata !DIExpression()), !dbg !62
  call void @llvm.dbg.declare(metadata %struct.S* %tmp5, metadata !76, metadata !DIExpression()), !dbg !63
  call void @llvm.dbg.declare(metadata i8** %tmp6, metadata !77, metadata !DIExpression()), !dbg !67
  call void @llvm.dbg.declare(metadata i8** %tmp7, metadata !78, metadata !DIExpression()), !dbg !68
  call void @llvm.dbg.declare(metadata i8* %tmp8, metadata !79, metadata !DIExpression()), !dbg !69
  call void @llvm.dbg.declare(metadata i32 %tmp9, metadata !80, metadata !DIExpression()), !dbg !70
  call void @llvm.dbg.declare(metadata i1 %tmp10, metadata !81, metadata !DIExpression()), !dbg !71
  br i1 %tmp10, label %bb16, label %bb11, !dbg !83

bb11:                                             ; preds = %bb
  %tmp12 = bitcast %struct.S* %tmp4 to i8*, !dbg !84
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %tmp12, i8* align 4 bitcast (%struct.S* @__const.main.s to i8*), i64 8, i1 false), !dbg !86
  %tmp13 = bitcast %struct.S* %tmp4 to i64*, !dbg !87
  %tmp14 = load i64, i64* %tmp13, align 4, !dbg !88
  call void @foo(i32 0, i64 %tmp14), !dbg !89
  %tmp15 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.3, i64 0, i64 0)), !dbg !90
  call void @llvm.dbg.declare(metadata i8* %tmp12, metadata !91, metadata !DIExpression()), !dbg !84
  call void @llvm.dbg.declare(metadata i64* %tmp13, metadata !92, metadata !DIExpression()), !dbg !87
  call void @llvm.dbg.declare(metadata i64 %tmp14, metadata !93, metadata !DIExpression()), !dbg !88
  call void @llvm.dbg.declare(metadata i32 %tmp15, metadata !94, metadata !DIExpression()), !dbg !90
  br label %bb21, !dbg !95

bb16:                                             ; preds = %bb
  %tmp17 = bitcast %struct.S* %tmp5 to i8*, !dbg !96
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %tmp17, i8* align 4 bitcast (%struct.S* @__const.main.s.4 to i8*), i64 8, i1 false), !dbg !98
  %tmp18 = bitcast %struct.S* %tmp5 to i64*, !dbg !99
  %tmp19 = load i64, i64* %tmp18, align 4, !dbg !100
  call void @foo(i32 100, i64 %tmp19), !dbg !101
  %tmp20 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.5, i64 0, i64 0)), !dbg !102
  call void @llvm.dbg.declare(metadata i8* %tmp17, metadata !103, metadata !DIExpression()), !dbg !96
  call void @llvm.dbg.declare(metadata i64* %tmp18, metadata !104, metadata !DIExpression()), !dbg !99
  call void @llvm.dbg.declare(metadata i64 %tmp19, metadata !105, metadata !DIExpression()), !dbg !100
  call void @llvm.dbg.declare(metadata i32 %tmp20, metadata !106, metadata !DIExpression()), !dbg !102
  br label %bb21, !dbg !107

bb21:                                             ; preds = %bb16, %bb11
  ret i32 0, !dbg !108
}

; Function Attrs: nounwind readonly
declare dso_local i32 @strcmp(i8*, i8*) #2

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #3

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #4

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { argmemonly nofree nounwind willreturn }
attributes #4 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #5 = { nounwind readonly }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}
!llvm.dbg.cu = !{!3}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 2, !"Debug Info Version", i32 3}
!2 = !{!"clang version 10.0.0-4ubuntu1 "}
!3 = distinct !DICompileUnit(language: DW_LANG_C99, file: !4, producer: "LLVM Version 13.0", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !5)
!4 = !DIFile(filename: "hello.ll", directory: "")
!5 = !{}
!6 = distinct !DISubprogram(name: "foo", linkageName: "foo", scope: !4, file: !4, line: 16, type: !7, scopeLine: 19, spFlags: DISPFlagDefinition, unit: !3, retainedNodes: !5)
!7 = !DISubroutineType(types: !8)
!8 = !{!9, !10, !11}
!9 = !DIBasicType(tag: DW_TAG_unspecified_type, name: "void")
!10 = !DIBasicType(name: "i32", size: 32, encoding: DW_ATE_unsigned)
!11 = !DIBasicType(name: "i64", size: 64, encoding: DW_ATE_unsigned)
!12 = !DILocation(line: 19, scope: !13)
!13 = distinct !DILexicalBlock(scope: !6, file: !4, line: 19)
!14 = !DILocation(line: 20, scope: !13)
!15 = !DILocation(line: 21, scope: !13)
!16 = !DILocation(line: 22, scope: !13)
!17 = !DILocation(line: 23, scope: !13)
!18 = !DILocation(line: 24, scope: !13)
!19 = !DILocation(line: 25, scope: !13)
!20 = !DILocation(line: 26, scope: !13)
!21 = !DILocation(line: 27, scope: !13)
!22 = !DILocation(line: 28, scope: !13)
!23 = !DILocation(line: 29, scope: !13)
!24 = !DILocation(line: 30, scope: !13)
!25 = !DILocation(line: 31, scope: !13)
!26 = !DILocation(line: 32, scope: !13)
!27 = !DILocation(line: 33, scope: !13)
!28 = !DILocation(line: 34, scope: !13)
!29 = !DILocation(line: 35, scope: !13)
!30 = !DILocation(line: 36, scope: !13)
!31 = !DILocalVariable(name: "tmp", scope: !13, file: !4, line: 19, type: !32)
!32 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "%struct.S*", baseType: !33, size: 64, align: 8)
!33 = !DICompositeType(tag: DW_TAG_structure_type, name: "struct.S", file: !4, size: 64, align: 4, elements: !34)
!34 = !{!35, !37}
!35 = !DIDerivedType(tag: DW_TAG_member, name: "struct.S.0", file: !4, baseType: !36)
!36 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "struct.S.1", file: !4, baseType: !38, offset: 32)
!38 = !DIBasicType(name: "i8", size: 8, encoding: DW_ATE_unsigned)
!39 = !DILocalVariable(name: "tmp2", scope: !13, file: !4, line: 20, type: !10)
!40 = !DILocalVariable(name: "tmp3", scope: !13, file: !4, line: 21, type: !10)
!41 = !DILocalVariable(name: "tmp4", scope: !13, file: !4, line: 22, type: !11)
!42 = !DILocalVariable(name: "tmp5", scope: !13, file: !4, line: 25, type: !10)
!43 = !DILocalVariable(name: "tmp6", scope: !13, file: !4, line: 26, type: !10)
!44 = !DILocalVariable(name: "tmp7", scope: !13, file: !4, line: 28, type: !10)
!45 = !DILocalVariable(name: "tmp8", scope: !13, file: !4, line: 29, type: !10)
!46 = !DILocalVariable(name: "tmp9", scope: !13, file: !4, line: 30, type: !36)
!47 = !DILocalVariable(name: "tmp10", scope: !13, file: !4, line: 31, type: !36)
!48 = !DILocalVariable(name: "tmp11", scope: !13, file: !4, line: 32, type: !49)
!49 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!50 = !DILocalVariable(name: "tmp12", scope: !13, file: !4, line: 33, type: !38)
!51 = !DILocalVariable(name: "tmp13", scope: !13, file: !4, line: 34, type: !38)
!52 = !DILocalVariable(name: "tmp14", scope: !13, file: !4, line: 35, type: !10)
!53 = !DILocalVariable(name: "tmp15", scope: !13, file: !4, line: 36, type: !10)
!54 = !DILocation(line: 37, scope: !13)
!55 = distinct !DISubprogram(name: "main", linkageName: "main", scope: !4, file: !4, line: 42, type: !56, scopeLine: 45, spFlags: DISPFlagDefinition, unit: !3, retainedNodes: !5)
!56 = !DISubroutineType(types: !57)
!57 = !{!10, !10, !38}
!58 = !DILocation(line: 45, scope: !59)
!59 = distinct !DILexicalBlock(scope: !55, file: !4, line: 45)
!60 = !DILocation(line: 46, scope: !59)
!61 = !DILocation(line: 47, scope: !59)
!62 = !DILocation(line: 48, scope: !59)
!63 = !DILocation(line: 49, scope: !59)
!64 = !DILocation(line: 50, scope: !59)
!65 = !DILocation(line: 51, scope: !59)
!66 = !DILocation(line: 52, scope: !59)
!67 = !DILocation(line: 53, scope: !59)
!68 = !DILocation(line: 54, scope: !59)
!69 = !DILocation(line: 55, scope: !59)
!70 = !DILocation(line: 56, scope: !59)
!71 = !DILocation(line: 57, scope: !59)
!72 = !DILocalVariable(name: "tmp", scope: !59, file: !4, line: 45, type: !10)
!73 = !DILocalVariable(name: "tmp2", scope: !59, file: !4, line: 46, type: !10)
!74 = !DILocalVariable(name: "tmp3", scope: !59, file: !4, line: 47, type: !38)
!75 = !DILocalVariable(name: "tmp4", scope: !59, file: !4, line: 48, type: !32)
!76 = !DILocalVariable(name: "tmp5", scope: !59, file: !4, line: 49, type: !32)
!77 = !DILocalVariable(name: "tmp6", scope: !59, file: !4, line: 53, type: !38)
!78 = !DILocalVariable(name: "tmp7", scope: !59, file: !4, line: 54, type: !38)
!79 = !DILocalVariable(name: "tmp8", scope: !59, file: !4, line: 55, type: !38)
!80 = !DILocalVariable(name: "tmp9", scope: !59, file: !4, line: 56, type: !10)
!81 = !DILocalVariable(name: "tmp10", scope: !59, file: !4, line: 57, type: !82)
!82 = !DIBasicType(name: "i1", size: 1, encoding: DW_ATE_unsigned)
!83 = !DILocation(line: 58, scope: !59)
!84 = !DILocation(line: 61, scope: !85)
!85 = distinct !DILexicalBlock(scope: !55, file: !4, line: 61)
!86 = !DILocation(line: 62, scope: !85)
!87 = !DILocation(line: 63, scope: !85)
!88 = !DILocation(line: 64, scope: !85)
!89 = !DILocation(line: 65, scope: !85)
!90 = !DILocation(line: 66, scope: !85)
!91 = !DILocalVariable(name: "tmp12", scope: !85, file: !4, line: 61, type: !38)
!92 = !DILocalVariable(name: "tmp13", scope: !85, file: !4, line: 63, type: !11)
!93 = !DILocalVariable(name: "tmp14", scope: !85, file: !4, line: 64, type: !11)
!94 = !DILocalVariable(name: "tmp15", scope: !85, file: !4, line: 66, type: !10)
!95 = !DILocation(line: 67, scope: !85)
!96 = !DILocation(line: 70, scope: !97)
!97 = distinct !DILexicalBlock(scope: !55, file: !4, line: 70)
!98 = !DILocation(line: 71, scope: !97)
!99 = !DILocation(line: 72, scope: !97)
!100 = !DILocation(line: 73, scope: !97)
!101 = !DILocation(line: 74, scope: !97)
!102 = !DILocation(line: 75, scope: !97)
!103 = !DILocalVariable(name: "tmp17", scope: !97, file: !4, line: 70, type: !38)
!104 = !DILocalVariable(name: "tmp18", scope: !97, file: !4, line: 72, type: !11)
!105 = !DILocalVariable(name: "tmp19", scope: !97, file: !4, line: 73, type: !11)
!106 = !DILocalVariable(name: "tmp20", scope: !97, file: !4, line: 75, type: !10)
!107 = !DILocation(line: 76, scope: !97)
!108 = !DILocation(line: 79, scope: !109)
!109 = distinct !DILexicalBlock(scope: !55, file: !4, line: 79)
