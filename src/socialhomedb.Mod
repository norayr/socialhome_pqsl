MODULE socialhomedb;
IMPORT postgres, Out, Strings;

(* get posts of user *)
(* SELECT * FROM public.content_content where author_id=1; *)
(* SELECT "id","text","guid","remote_created","service_label","created","modified","author_id","order","pinned","visibility","oembed_id","opengraph_id","rendered","parent_id","share_of_id","content_type","reply_count","shares_count","local","show_preview","federate","include_following","fid","uuid","root_parent_id" FROM "public"."content_content" WHERE "author_id" = '1' AND "order" = '0' *)

(* SELECT id FROM "public"."content_content" where author_id=1 and content_type=0; *)
PROCEDURE getListOfPosts*(VAR userid: ARRAY OF CHAR; public : BOOLEAN): StringList.TStringList;
VAR
  cmd: ARRAY 128 OF CHAR;
  strs: StringList.TStringList;
BEGIN
  COPY 'SELECT id FROM "public"."content_content" where author_id=', cmd);
  Strings.Append(userid, cmd);
  Strings.Append(" and content_type=0", cmd);
  IF public THEN
    Strings.Append(" and visibility=0", cmd)
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

END socialhomedb.
