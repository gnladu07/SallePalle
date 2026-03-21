package com.itwillbs.persistence;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;
import com.itwillbs.domain.ChatMessageVO;
import com.itwillbs.domain.ChatRoomVO;

@Repository
public class ChatDAOImpl implements ChatDAO {

    private static final String NAMESPACE = "com.itwillbs.mapper.ChatMapper.";
    @Inject private SqlSession sqlSession;

    @Override
    public int findRoom(int trade_id, int buyer_id) {
        Map<String, Integer> paramMap = new HashMap<>();
        paramMap.put("trade_id", trade_id);
        paramMap.put("buyer_id", buyer_id);
        return sqlSession.selectOne(NAMESPACE + "findRoom", paramMap);
    }

    @Override
    public void createRoom(ChatRoomVO vo) {
        sqlSession.insert(NAMESPACE + "createRoom", vo);
    }

    @Override
    public void insertMessage(ChatMessageVO vo) {
        sqlSession.insert(NAMESPACE + "insertMessage", vo);
    }

    @Override
    public List<ChatMessageVO> getMessagesByRoomId(int room_id) {
        return sqlSession.selectList(NAMESPACE + "getMessagesByRoomId", room_id);
    }

    @Override
    public List<ChatRoomVO> getRoomList(int member_id) {
        return sqlSession.selectList(NAMESPACE + "getRoomList", member_id);
    }

	@Override
	public ChatRoomVO getRoom(int room_id) {
		return sqlSession.selectOne(NAMESPACE + "getRoom", room_id);
	}
	
	@Override
    public void deleteChatMessages(int room_id) throws Exception {
        sqlSession.delete(NAMESPACE + "deleteChatMessages", room_id);
    }

    @Override
    public void deleteChatRoom(int room_id) throws Exception {
        sqlSession.delete(NAMESPACE + "deleteChatRoom", room_id);
    }

    @Override
    public void markMessagesAsRead(Map<String, Object> paramMap) throws Exception {
        sqlSession.update(NAMESPACE + "markMessagesAsRead", paramMap);
    }

    @Override
    public List<ChatRoomVO> getChatHistoryLog(int member_id) throws Exception {
        return sqlSession.selectList(NAMESPACE + "getChatHistoryLog", member_id);
    }

    @Override
    public void flagChatRoom(int room_id) throws Exception {
        sqlSession.update(NAMESPACE + "flagChatRoom", room_id);
    }

    @Override
    public List<ChatRoomVO> getAdminChatList() throws Exception {
        return sqlSession.selectList(NAMESPACE + "getAdminChatList");
    }

    @Override
    public void adminSoftCloseRoom(int room_id) throws Exception {
        sqlSession.update(NAMESPACE + "adminSoftCloseRoom", room_id);
    }

    @Override
    public List<ChatRoomVO> getAdminClosedChatList() throws Exception {
        return sqlSession.selectList(NAMESPACE + "getAdminClosedChatList");
    }


}