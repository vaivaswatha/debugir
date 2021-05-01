; ModuleID = './hello.ll'
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
define dso_local void @foo(i32 %arg, i64 %arg1) #0 {
bb:
  %tmp = alloca %struct.S, align 4
  %tmp2 = alloca i32, align 4
  %tmp3 = alloca i32, align 4
  %tmp4 = bitcast %struct.S* %tmp to i64*
  store i64 %arg1, i64* %tmp4, align 4
  store i32 %arg, i32* %tmp2, align 4
  %tmp5 = load i32, i32* %tmp2, align 4
  %tmp6 = add nsw i32 %tmp5, 1
  store i32 %tmp6, i32* %tmp3, align 4
  %tmp7 = load i32, i32* %tmp3, align 4
  %tmp8 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 %tmp7)
  %tmp9 = getelementptr inbounds %struct.S, %struct.S* %tmp, i32 0, i32 0
  %tmp10 = load float, float* %tmp9, align 4
  %tmp11 = fpext float %tmp10 to double
  %tmp12 = getelementptr inbounds %struct.S, %struct.S* %tmp, i32 0, i32 1
  %tmp13 = load i8, i8* %tmp12, align 4
  %tmp14 = sext i8 %tmp13 to i32
  %tmp15 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.1, i64 0, i64 0), double %tmp11, i32 %tmp14)
  ret void
}

declare dso_local i32 @printf(i8*, ...) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %arg, i8** %arg1) #0 {
bb:
  %tmp = alloca i32, align 4
  %tmp2 = alloca i32, align 4
  %tmp3 = alloca i8**, align 8
  %tmp4 = alloca %struct.S, align 4
  %tmp5 = alloca %struct.S, align 4
  store i32 0, i32* %tmp, align 4
  store i32 %arg, i32* %tmp2, align 4
  store i8** %arg1, i8*** %tmp3, align 8
  %tmp6 = load i8**, i8*** %tmp3, align 8
  %tmp7 = getelementptr inbounds i8*, i8** %tmp6, i64 0
  %tmp8 = load i8*, i8** %tmp7, align 8
  %tmp9 = call i32 @strcmp(i8* %tmp8, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.2, i64 0, i64 0)) #4
  %tmp10 = icmp ne i32 %tmp9, 0
  br i1 %tmp10, label %bb16, label %bb11

bb11:                                             ; preds = %bb
  %tmp12 = bitcast %struct.S* %tmp4 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %tmp12, i8* align 4 bitcast (%struct.S* @__const.main.s to i8*), i64 8, i1 false)
  %tmp13 = bitcast %struct.S* %tmp4 to i64*
  %tmp14 = load i64, i64* %tmp13, align 4
  call void @foo(i32 0, i64 %tmp14)
  %tmp15 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.3, i64 0, i64 0))
  br label %bb21

bb16:                                             ; preds = %bb
  %tmp17 = bitcast %struct.S* %tmp5 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %tmp17, i8* align 4 bitcast (%struct.S* @__const.main.s.4 to i8*), i64 8, i1 false)
  %tmp18 = bitcast %struct.S* %tmp5 to i64*
  %tmp19 = load i64, i64* %tmp18, align 4
  call void @foo(i32 100, i64 %tmp19)
  %tmp20 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.5, i64 0, i64 0))
  br label %bb21

bb21:                                             ; preds = %bb16, %bb11
  ret i32 0
}

; Function Attrs: nounwind readonly
declare dso_local i32 @strcmp(i8*, i8*) #2

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #3

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { argmemonly nounwind willreturn }
attributes #4 = { nounwind readonly }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 10.0.0-4ubuntu1 "}
