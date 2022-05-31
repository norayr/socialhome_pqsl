MODULE socialhomedb;
IMPORT postgres, Out, Strings := oocStrings, StringList, strutils;

PROCEDURE clean(VAR strs: StringList.TStringList);
VAR
  e : StringList.Node;
  L : StringList.TList;
  i, l : INTEGER;
BEGIN
  NEW(e); NEW(L);
  L := strs;
  REPEAT
    e := strs.Get(L, i);
    IF e # NIL THEN
      l := Strings.Length(e.obj(StringList.TString).str^) - 1;
      IF e.obj(StringList.TString).str[l] = '+' THEN
        Strings.Delete(e.obj(StringList.TString).str^, l, 1);
        strutils.RemoveRightChars(e.obj(StringList.TString).str^, ' ');
        l := Strings.Length(e.obj(StringList.TString).str^) - 1 ;
        IF (e.obj(StringList.TString).str^[l-1] = '\') & (e.obj(StringList.TString).str^[l] = 'r') THEN
          Strings.Delete(e.obj(StringList.TString).str^, l-1, 2);
        END;
      END; (* clean *)
    END;
    INC(i)
  UNTIL i = strs.Count;
END clean;

PROCEDURE getCreationTime*(postid: ARRAY OF CHAR; VAR time: ARRAY OF CHAR);
VAR
  cmd: ARRAY 256 OF CHAR;
  strs: StringList.TStringList;
  e: StringList.Node;
  p: INTEGER;
BEGIN
  Out.String("getting creation time of post "); Out.String(postid); Out.Ln;
  COPY ('SELECT created from "public"."content_content" WHERE id=', cmd);
  Strings.Append("'", cmd);
  Strings.Append(postid, cmd);
  Strings.Append("';", cmd);
  Out.String(cmd); Out.Ln;
  strs := postgres.query(cmd);
  strs := postgres.query(cmd);
  strs.Delete(strs, 0);
  strs.Delete(strs, 0);
  strs.Delete(strs, strs.Count-1);
  strs.Delete(strs, strs.Count-1);
  strs.Delete(strs, strs.Count-1);
  e := strs.Get(strs, strs.Count-1);
  Strings.Assign(e.obj(StringList.TString).str^, time);
  (* now check if the line contains dot, then cut everything from right till the dot included *)
    p := strutils.Pos('.', time, 0);
  IF p # 0 THEN
    Strings.Delete(time, p, Strings.Length(time)-p);
  END
END getCreationTime;

PROCEDURE getText*(postid: ARRAY OF CHAR): StringList.TStringList;
VAR
  cmd: ARRAY 256 OF CHAR;
  strs: StringList.TStringList;
BEGIN
  COPY('SELECT text FROM "public"."content_content" WHERE id=', cmd);
  Strings.Append("'", cmd);
  Strings.Append(postid, cmd);
  Strings.Append("';", cmd);
  Out.String(cmd); Out.Ln;
  strs := postgres.query(cmd);
  Out.String(cmd); Out.Ln;
  strs := postgres.query(cmd);
  Out.String("cleaning"); Out.Ln;
  strs.Delete(strs, 0);
  strs.Delete(strs, 0);
  Out.String("still cleaning"); Out.Ln;
  strs.Delete(strs, strs.Count-1);
  strs.Delete(strs, strs.Count-1);
  strs.Delete(strs, strs.Count-1);
  Out.String("calling clean"); Out.Ln;
  clean(strs);
  Out.String("clean over"); Out.Ln;
  RETURN(strs);
END getText;

PROCEDURE getPostGuid*(VAR id, guid: ARRAY OF CHAR);
VAR
  cmd: ARRAY 64 OF CHAR;
BEGIN
  COPY('SELECT guid FROM "public"."content_content" WHERE id=', cmd);
  Strings.Append("'", cmd);
  Strings.Append(id, cmd);
  Strings.Append("';", cmd);
  Out.String(cmd); Out.Ln;
  postgres.queryL(cmd, guid);
END getPostGuid;

(* SELECT id FROM "public"."content_content" where author_id=1 and content_type=0; *)
PROCEDURE getListOfPosts*(VAR userid: ARRAY OF CHAR; public : BOOLEAN): StringList.TStringList;
VAR
  cmd: ARRAY 128 OF CHAR;
  strs: StringList.TStringList;
BEGIN
  COPY ('SELECT id FROM "public"."content_content" where author_id=', cmd);
  Strings.Append(userid, cmd);
  Strings.Append(" and content_type=0", cmd);
  IF public THEN
    Strings.Append(" and visibility=0 ORDER BY id", cmd)
  END;
  Strings.Append(";", cmd);
  Out.String(cmd); Out.Ln;
  strs := postgres.query(cmd);
  strs.Delete(strs, 0);
  strs.Delete(strs, 0);
  strs.Delete(strs, strs.Count-1);
  strs.Delete(strs, strs.Count-1);
  strs.Delete(strs, strs.Count-1);
  RETURN(strs);
END getListOfPosts;

PROCEDURE getAuthorId*(VAR username, id: ARRAY OF CHAR);
VAR
  cmd : ARRAY 96 OF CHAR;
BEGIN
  (* SELECT id FROM "public"."users_user" where username='inky'; *)
  COPY('SELECT id FROM "public"."users_user" where username=', cmd);
  Strings.Append("'", cmd);
  Strings.Append(username, cmd);
  Strings.Append("';", cmd);
  Out.String(cmd); Out.Ln;
  postgres.queryL(cmd, id);
END getAuthorId;

BEGIN
  postgres.setUser("socialhome");
  postgres.setDatabase("tsmakut");
END socialhomedb.
