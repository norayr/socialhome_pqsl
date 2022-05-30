MODULE socialhome;
IMPORT postgres, Out, Strings;

(* get posts of user *)
(* SELECT * FROM public.content_content where author_id=1; *)
(* SELECT "id","text","guid","remote_created","service_label","created","modified","author_id","order","pinned","visibility","oembed_id","opengraph_id","rendered","parent_id","share_of_id","content_type","reply_count","shares_count","local","show_preview","federate","include_following","fid","uuid","root_parent_id" FROM "public"."content_content" WHERE "author_id" = '1' AND "order" = '0' *)

PROCEDURE getAuthorId*(VAR username, id: ARRAY OF CHAR);
VAR
  cmd : ARRAY 96 OF CHAR;
BEGIN
  (* SELECT id FROM "public"."users_user" where username='inky'; *)
  COPY('SELECT id FROM "public"."users_user" where username='", cmd);
  Strings.Append(username, cmd);
  Strings.Append("';", cmd);
  Out.String(cmd); Out.Ln;
  postgres.queryL(cmd, id);
END;

(* SELECT * FROM "public"."content_content" where author_id=1 and content_type=0; *)

END socialhome.
