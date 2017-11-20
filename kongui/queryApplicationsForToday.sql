	<select id="queryApplicationsForToday" resultMap="BaseResultMap">
		SELECT *
		FROM (
		SELECT
		ROW_NUMBER()
		OVER (
		ORDER BY DateAdded DESC ) rank,
		tmp.*
		FROM (
		SELECT
		ROW_NUMBER()
		OVER (
		PARTITION BY i.userId
		ORDER BY
		i.DateAdded DESC
		) row,
		i.*
		FROM InstallmentApplicationObjects i
		WHERE i.MerchantStoreId IN (${posIdStr})
		<![CDATA[
		AND i.DateAdded > CONVERT(VARCHAR(10), GETDATE(), 120)
		]]>
		<if test="statusDescription!=null and statusDescription!=''">
			<choose>
				<when test="statusDescription == 'inFilling'">
					<![CDATA[
					AND i.Status >= 0 AND i.Status < 10
					]]>
				</when>
				<when test="statusDescription == 'inAudited'">
					<![CDATA[
					AND i.Status >= 10 AND i.Status < 35
					]]>
				</when>
				<when test="statusDescription == 'passAudited'">
					<![CDATA[
					AND i.Status >= 35 AND i.Status <> 40
					]]>
				</when>
				<when test="statusDescription == 'rejected'">
					<![CDATA[
					AND i.Status = 40
					]]>
				</when>
				<when test="statusDescription == 'canceled'">
					<![CDATA[
					AND i.Status = -1
					]]>
				</when>
			</choose>
		</if>
		) AS tmp
		WHERE tmp.row = 1) AS ttmp
		<![CDATA[
		WHERE ttmp.rank > #{begin} AND ttmp.rank <= #{end}
		]]>
	</select>


