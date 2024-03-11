[1mdiff --git a/Birthday-2024-Project/Resources/SubmittedLevels/Beldantazar.tres b/Birthday-2024-Project/Resources/SubmittedLevels/Beldantazar.tres[m
[1mindex bcff8ed..0e765f3 100644[m
[1m--- a/Birthday-2024-Project/Resources/SubmittedLevels/Beldantazar.tres[m
[1m+++ b/Birthday-2024-Project/Resources/SubmittedLevels/Beldantazar.tres[m
[36m@@ -1,6 +1,8 @@[m
[31m-[gd_resource type="Resource" script_class="LevelSetup" load_steps=2 format=3 uid="uid://dmh7scs86ghmj"][m
[32m+[m[32m[gd_resource type="Resource" script_class="LevelSetup" load_steps=4 format=3 uid="uid://dmh7scs86ghmj"][m
 [m
 [ext_resource type="Script" path="res://Scripts/LevelSetup.gd" id="1_17dl6"][m
[32m+[m[32m[ext_resource type="Texture2D" uid="uid://bed44fisctfq4" path="res://Art/LevelPreviews/BeldantazarLevelDone.png" id="1_dbac7"][m
[32m+[m[32m[ext_resource type="Texture2D" uid="uid://b1eyl23peebkf" path="res://Art/LevelPreviews/BeldantazarLevel.png" id="2_01kqe"][m
 [m
 [resource][m
 script = ExtResource("1_17dl6")[m
[36m@@ -9,3 +11,5 @@[m [mjsonData = "[\"{\\\"PIECE_SETUP_GRID_POSITION_X_KEY\\\":0,\\\"PIECE_SETUP_GRID_P[m
 author = "Beldantazar"[m
 message = "Happy Birthday to the greenest Kirin oshi :FaunaLoveRedYT: I hope this puzzle manages to convey how much you have fit into our hearts over the years."[m
 levelName = "matchaless-kirin"[m
[32m+[m[32mlevelPreview = ExtResource("2_01kqe")[m
[32m+[m[32mlevelComplete = ExtResource("1_dbac7")[m
[1mdiff --git a/Birthday-2024-Project/ScenePrefabs/Pieces/ele_fauna.tscn b/Birthday-2024-Project/ScenePrefabs/Pieces/ele_fauna.tscn[m
[1mindex d1ce644..9ce7d5d 100644[m
[1m--- a/Birthday-2024-Project/ScenePrefabs/Pieces/ele_fauna.tscn[m
[1m+++ b/Birthday-2024-Project/ScenePrefabs/Pieces/ele_fauna.tscn[m
[36m@@ -8,7 +8,7 @@[m [mpieceShape = "111[m
 111[m
 011[m
 011"[m
[31m-    [m
[32m+[m
 [node name="Sprite2D" parent="." index="0"][m
 position = Vector2(-60, 0)[m
 texture = ExtResource("2_bg64v")[m
[1mdiff --git a/Birthday-2024-Project/ScenePrefabs/Pieces/gold_apple.tscn b/Birthday-2024-Project/ScenePrefabs/Pieces/gold_apple.tscn[m
[1mindex c7d89e3..260fabd 100644[m
[1m--- a/Birthday-2024-Project/ScenePrefabs/Pieces/gold_apple.tscn[m
[1m+++ b/Birthday-2024-Project/ScenePrefabs/Pieces/gold_apple.tscn[m
[36m@@ -4,6 +4,7 @@[m
 [ext_resource type="Texture2D" uid="uid://csbmmbti02bpt" path="res://Art/OfficialPieceArt/FaunaBdayProject2024SmolBlocksGoldenAppleBlockerNoBg.png" id="2_6u7kx"][m
 [m
 [node name="gold_apple" instance=ExtResource("1_u42iy")][m
[32m+[m[32mvisible = false[m
 pieceShape = "1"[m
 isBlocker = true[m
 [m
[1mdiff --git a/Birthday-2024-Project/ScenePrefabs/Pieces/matcha_1.tscn b/Birthday-2024-Project/ScenePrefabs/Pieces/matcha_1.tscn[m
[1mindex fc30340..153326c 100644[m
[1m--- a/Birthday-2024-Project/ScenePrefabs/Pieces/matcha_1.tscn[m
[1m+++ b/Birthday-2024-Project/ScenePrefabs/Pieces/matcha_1.tscn[m
[36m@@ -4,6 +4,7 @@[m
 [ext_resource type="Texture2D" uid="uid://drg2trhl7s24l" path="res://Art/OfficialPieceArt/Matcha1.png" id="2_ur7ch"][m
 [m
 [node name="matcha_1" instance=ExtResource("1_2ar1r")][m
[32m+[m[32mvisible = false[m
 pieceShape = "1111[m
 1110[m
 1110"[m
[1mdiff --git a/Birthday-2024-Project/ScenePrefabs/Pieces/matcha_2.tscn b/Birthday-2024-Project/ScenePrefabs/Pieces/matcha_2.tscn[m
[1mindex ccb3362..9f2a884 100644[m
[1m--- a/Birthday-2024-Project/ScenePrefabs/Pieces/matcha_2.tscn[m
[1m+++ b/Birthday-2024-Project/ScenePrefabs/Pieces/matcha_2.tscn[m
[36m@@ -4,6 +4,7 @@[m
 [ext_resource type="Texture2D" uid="uid://dytum2aj5qbkp" path="res://Art/OfficialPieceArt/Matcha2.png" id="2_jt15s"][m
 [m
 [node name="matcha_2" instance=ExtResource("1_p2o4v")][m
[32m+[m[32mvisible = false[m
 pieceShape = "010[m
 111[m
 001"[m
[1mdiff --git a/Birthday-2024-Project/ScenePrefabs/Pieces/snail.tscn b/Birthday-2024-Project/ScenePrefabs/Pieces/snail.tscn[m
[1mindex df12833..dda073f 100644[m
[1m--- a/Birthday-2024-Project/ScenePrefabs/Pieces/snail.tscn[m
[1m+++ b/Birthday-2024-Project/ScenePrefabs/Pieces/snail.tscn[m
[36m@@ -4,6 +4,7 @@[m
 [ext_resource type="Texture2D" uid="uid://cyaxerqj7bgms" path="res://Art/OfficialPieceArt/Snail.png" id="2_1fwf5"][m
 [m
 [node name="snail" instance=ExtResource("1_kkwfv")][m
[32m+[m[32mvisible = false[m
 pieceShape = "01[m
 11"[m
 isBlocker = true[m
[1mdiff --git a/Birthday-2024-Project/ScenePrefabs/Pieces/wrench.tscn b/Birthday-2024-Project/ScenePrefabs/Pieces/wrench.tscn[m
[1mindex abe367e..f1b83b7 100644[m
[1m--- a/Birthday-2024-Project/ScenePrefabs/Pieces/wrench.tscn[m
[1m+++ b/Birthday-2024-Project/ScenePrefabs/Pieces/wrench.tscn[m
[36m@@ -4,6 +4,7 @@[m
 [ext_resource type="Texture2D" uid="uid://rr1lnxrv1n06" path="res://Art/OfficialPieceArt/wrench.png" id="2_xt5ry"][m
 [m
 [node name="wrench" instance=ExtResource("1_10ch8")][m
[32m+[m[32mvisible = false[m
 pieceShape = "1[m
 1"[m
 isBlocker = true[m
